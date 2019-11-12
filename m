Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9355FF8C7E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 11:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfKLKJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 05:09:19 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725834AbfKLKJT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 05:09:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573553358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=rm+SpsgER6q0ZzJGxmttnhDXfih8qrCKpsGq3yb+Vgs=;
        b=DinifuHftnKa7WSB9CNHVcMks0nibT9gioYuV4pMW5WJOGgR1JoSa781n6793/7Smgyo8G
        9jtcgmAgUGNvhpJ0VfVD1edKh7VLDf+r0AzwEzIxHCVvqxSrvXPd930WpkqPSL85OL6/jQ
        ERCOhYLZ1YUYqsyMKxgdQbhVVmiTGJw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-r-KjIYtaMpScjuWMASbFmg-1; Tue, 12 Nov 2019 05:09:17 -0500
Received: by mail-wm1-f70.google.com with SMTP id m68so1216729wme.7
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2019 02:09:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/T+UqvDPJA0ruFuxC0ui4R1v70oUmaDOHs4UxSNtf/o=;
        b=COG0hDseYpWjsC7Qxy/dCo4pHIV8CSZQSTVI3IoLKgHhUep6gqBf81Ly+PGyzudDgV
         Cx2DFYMQN8R6Z37CbZwT6URymktpxZPw+cZnf3gn3tznjxauqxSolEzSXVdrJCZ3glH8
         06QuWEOfy9OzX7PU/czc8ui8W8naeunavxv0ZkUNjQWV85K4Yr7ZCiFwhsYpjSpQXpYo
         bH1Bl91z8sxAiSBtAv061Au+9c7wJtkzSAYxmRPsut6xBDxe51eio01vN8C9UXmsPHmF
         S1JuUvSBEzFvy8RASbiuHx7T1j2hdkjuizBVFSgZXPG1HmIOcGocNpaFTx7arGUM+sUo
         /05A==
X-Gm-Message-State: APjAAAUUglZ9dwRwcNDod0Q3aH5BsdLhyYqASn0krzoN2iJUKPsr1vga
        zjIz/NiXvbHYqWQfhya05Y46dt0wKw5QIhlTD9fbBX8UyRysB6IYmlDQbksax5bk9I/nfjzNeX0
        ie0DOwR8vKXD/
X-Received: by 2002:a05:600c:22cb:: with SMTP id 11mr3211638wmg.117.1573553355857;
        Tue, 12 Nov 2019 02:09:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxieILYD7Oki2LtPWxGLPvRXneVlPzXp94IaP9x7iQbDbM7jR4WAKOfSK+ZLP0yVwAzUEp3zw==
X-Received: by 2002:a05:600c:22cb:: with SMTP id 11mr3211614wmg.117.1573553355624;
        Tue, 12 Nov 2019 02:09:15 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q15sm10709704wrs.91.2019.11.12.02.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 02:09:15 -0800 (PST)
Subject: Re: [PATCH v4 0/6] KVM: x86/vPMU: Efficiency optimization by reusing
 last created perf_event
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20191027105243.34339-1-like.xu@linux.intel.com>
 <20191028164324.GJ4097@hirez.programming.kicks-ass.net>
 <dcbc78f5-c267-d5be-f4e8-deaebf91fe1f@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <21372ed6-b8c1-3609-1ab8-2d566a4319e6@redhat.com>
Date:   Tue, 12 Nov 2019 11:09:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dcbc78f5-c267-d5be-f4e8-deaebf91fe1f@linux.intel.com>
Content-Language: en-US
X-MC-Unique: r-KjIYtaMpScjuWMASbFmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 07:08, Like Xu wrote:
>=20
> For vPMU, please review two more patches as well:
> +
> https://lore.kernel.org/kvm/20191030164418.2957-1-like.xu@linux.intel.com=
/
> (kvm)

If I understand this patch correctly, you are patching the CPUID values
passed to the KVM_SET_CPUID2 ioctl if they are not valid for the host.
Generally we don't do that, if there is garbage in CPUID the behavior of
the guest will be unreliable.

Paolo

