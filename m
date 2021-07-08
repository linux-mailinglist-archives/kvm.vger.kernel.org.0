Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3BF3C179F
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGHRBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 13:01:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhGHRBk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 13:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+MxxEIgHppIPoGs9NgPZPuRjgmYFQ760KzTDD/t7B8=;
        b=OO7SaQnWeN6Dpw4mLfL9P1duZTrDE9/azbildTwa965GJZjInR0D2l7arg8STAUD+HcZfI
        NZpeKU+YGenyS6Gjhe/fjBa+xAxkNg8+LLcvXNJtEECGtjEY6yAZ7VzpJue44sb0eO622m
        tNskAAO/mkM1d+butG1B6RcI0j2OFmY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-uWoQXdbxOTifvIGgywm6gg-1; Thu, 08 Jul 2021 12:58:56 -0400
X-MC-Unique: uWoQXdbxOTifvIGgywm6gg-1
Received: by mail-ed1-f69.google.com with SMTP id m15-20020a056402430fb0290399da445c17so3679394edc.8
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1+MxxEIgHppIPoGs9NgPZPuRjgmYFQ760KzTDD/t7B8=;
        b=HqCC/SEsFyFrk0RUNk01itnxa7QCbvAPybXdY0op48w03V1yZjznTFd2Y5/b4YKi/o
         HWyjxtLsLzxl/HJyJdZFTFnj6HBDEkiISJQ4Cgwv+iusLTjcF+663jfygvmehS9m+lcq
         pJH6hEwRacyYolfYKn0bjstBsvLqW4pcJkHxMcOjOjwUQTqOyQSKP+NDNYzbBL2iCACu
         YmemlIROeJNmR8s3QULPd6+rsuUTsj9xkmf/yTfHQMx9Jzx3gJbiwF+cy7ELM8SP6N3p
         umiP7IJYZaTh3fnSBaQ5641XWHhqEmRFQe6hnZ09Biz9C6tA68QD4FRACc8r4l+/V4tW
         3TyQ==
X-Gm-Message-State: AOAM533YteQZ9GvYanrN7Eqr1XrMGxsDtwg0UMuMSJXrHjLa1rGvMj3d
        i6ulc1jPLHyMpKx3uFcVSe7RtOV6seBJC0bvx0XKWn4OZ97mQ+ga8p9S1IRyTLBiWC8V0iZgcC5
        yYwfc06Uh7zSg
X-Received: by 2002:a05:6402:1057:: with SMTP id e23mr40673377edu.352.1625763535370;
        Thu, 08 Jul 2021 09:58:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwskCkYwrqK5gDNs5Pk01sWgeZ01rPE8fbcAvoaGolRa9Pk5OAwoAWpbIh28BrbHtDOfUOY/w==
X-Received: by 2002:a05:6402:1057:: with SMTP id e23mr40673368edu.352.1625763535253;
        Thu, 08 Jul 2021 09:58:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u26sm1170302ejx.8.2021.07.08.09.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:58:54 -0700 (PDT)
Subject: Re: [PATCH next] kvm: debugfs: fix memory leak in
 kvm_create_vm_debugfs
To:     Jing Zhang <jingzhangos@google.com>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20210701195500.27097-1-paskripkin@gmail.com>
 <CAAdAUtiAA+H178X7pU1KLzKwmPZ1jTOUpmsP0TvFzqVH5gJAdg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b028e3d-d363-05cd-3dc3-8ccc5704ae1c@redhat.com>
Date:   Thu, 8 Jul 2021 18:58:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAAdAUtiAA+H178X7pU1KLzKwmPZ1jTOUpmsP0TvFzqVH5gJAdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/21 23:24, Jing Zhang wrote:
> In commit bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> loop for filling debugfs_stat_data was copy-pasted 2 times, but
> in the second loop pointers are saved over pointers allocated
> in the first loop. It causes memory leak. Fix it.
> 
> Fixes: bc9e9e672df9 ("KVM: debugfs: Reuse binary stats descriptors")
> Signed-off-by: Pavel Skripkin<paskripkin@gmail.com>
> ---

Queued, thanks.

Paolo

