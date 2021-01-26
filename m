Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844A130439B
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392387AbhAZQSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:18:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391045AbhAZQSW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 11:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611677816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2XqO2IE9er0Vnt1upnepDYuDbwSqa6/W7rjIB2a0Ho=;
        b=U6wrDmjD60c72056rjTZ34AT+uroUMcvPBBlFKENDHGNn72birBTJGcBJ9IdBCjETEvHwT
        fB4U1jgnQj2CAlxia3rKOAgLn/QKxf5HQTlArVC0Xw6uDQN9NGdlEMcQHaL9uaWO+GUeNm
        33ABN34QZqc1JoL0xeAx3JJKqnZNSKI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-ZZp3Ul2mNh6TYZmURosNMg-1; Tue, 26 Jan 2021 11:16:54 -0500
X-MC-Unique: ZZp3Ul2mNh6TYZmURosNMg-1
Received: by mail-ed1-f69.google.com with SMTP id f21so9666417edx.23
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:16:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K2XqO2IE9er0Vnt1upnepDYuDbwSqa6/W7rjIB2a0Ho=;
        b=Vi15tkPLGVZIwfi6pt9fGNMtmPzGvPyVIebirp6r4XSfHKRjmI0SJwzb+P4CHOUIGb
         SdowLf1oY+q5j0+3cJvlYWUoYLl98rWhe/+Q8JlxBtsC8V8mbk5R2Y+ghUj2Zx5gvaPQ
         LsQbuHnxJoPBSHqZoJbtCA5vvsSVwpKghsZ776DeDbFb4nSgAv8sIA9esRviFccU00KU
         Vs2EAZyxFHIgkCquMjwDZrtHGVLIJL4fKvjvgk+isnUNB7FQxF/KOqPyBzGRPQJ5mBTw
         JvXLZFkK+546lmwPNZrfRbJj4eQA9F/NmSrSorCX4+/WGM5/4wsFn9tGW03ZEVO+SxU3
         9MAA==
X-Gm-Message-State: AOAM532Ge3vLCgxIYYlTD0Fs7zoiubK+quuSWIcR6depRBhY1RYN7g0D
        SnQuDAMWIwflT5PX/8z1LBeiP2m8a0a8sn1cQ3VLt76XcOyRkhMsp6R9keKaIkxulkuMVS2aEJU
        WFK5nK9nzvYRi
X-Received: by 2002:aa7:c0cd:: with SMTP id j13mr5088183edp.217.1611677813162;
        Tue, 26 Jan 2021 08:16:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwUVsa1+h9mV52lborPQq/Yk6OPqXNM0aFL8OSySGRwHH9vH27Wb1FYyZrYpGpuWxXNKwoPw==
X-Received: by 2002:aa7:c0cd:: with SMTP id j13mr5088176edp.217.1611677813034;
        Tue, 26 Jan 2021 08:16:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k22sm12960851edv.33.2021.01.26.08.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:16:51 -0800 (PST)
Subject: Re: [PATCH v4 4/6] sev/i386: Don't allow a system reset under an
 SEV-ES guest
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
 <c40de4c1bf4d14d60942fba86b2827543c19374a.1601060620.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66a57543-a98a-d62e-5213-e203efda5dce@redhat.com>
Date:   Tue, 26 Jan 2021 17:16:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c40de4c1bf4d14d60942fba86b2827543c19374a.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 21:03, Tom Lendacky wrote:
> 
>  {
> -    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> +    if (!cpus_are_resettable()) {
> +        error_report("cpus are not resettable, terminating");
> +        shutdown_requested = reason;
> +    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {

The error should not be emitted if "no_reboot && reason != 
SHUTDOWN_CAUSE_SUBSYSTEM_RESET" (the condition has changed a bit in 
latest QEMU but the idea is the same).

This is because whoever invoked QEMU could already know about this 
SEV-ES limitation, and use -no-reboot (aka -action reset=shutdown in 
6.0) in order to change the forbidden warm reset into a shutdown+restart 
cold reset.

Paolo

