Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9850E470FEA
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 02:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbhLKBlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 20:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhLKBlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 20:41:15 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA964C061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:37:39 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so35948922edv.1
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pzG/Li+M9QEbAKeuK7YjBwTyxjI6r5pab/36cXoNYk8=;
        b=G58mbVf0M0S0PZ2vYal6M2Vr6sRfhKYUxx9g3Vz4swn2dyzmIEIzabhc0puq5k8Ytp
         TSLH9ZGSYMQBK9rOFm/UQOZ9p6WOjKnHbL2tsckIvSfihRX/igGJm8mnYYkRtnhRvoIV
         eBJSkxqDQ2WAyKoKm53u8EaK/DD/8WpTsU/M400hNkclxdbtmabNJhyVqt877HWjYExF
         koVOEtGaRRsIoaIaWWGuFO08VqCzgCtuerRCLm/HqsganZcjUvM7UuAZbEFonwcOuNFf
         xN87daMjU40wMl77+UEb3P/2bsnxkBEvsAaaQ8t6RYRo7FFV9hV1O2cDLiSrmuf+GsAU
         KuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pzG/Li+M9QEbAKeuK7YjBwTyxjI6r5pab/36cXoNYk8=;
        b=2kWMKKLjVf0aq+QO/DI/QfhmMX7joh9iQehOm/Lpfax/gsUkt/M1ry8Tl507YXnZcg
         9UPL1GCnNU3UAxweemY5cz+EPXhz6dQkfsKcWdz5NbhhPukj7HAD2DnafTz26QEbH0IP
         w+iX06qjtZiJnEhPGYLzQv51jmIQ/B+K535YewQTPm7yPU5I/CqULglqjVsT5kN3P7JY
         lwKBdRmhAJcPUVNrOxIW50EmmnNBonXU3RrNT72h+aE5QfTJRqKxc63rImqlUaUtkU7e
         yu1NtFF7nQEYtZyjcibiuSYmZe2m24T66PtAGGmRpmvh2/gFhGs2Bvo/oPBEEXh/ZkFZ
         zYYA==
X-Gm-Message-State: AOAM530txPYe8V1yIXQs1kp9FbUKlkXavEN7xE2Lj1GgTNzAUcDcbyUW
        hpHrKNjvhOUFAlQuvnZpxa0=
X-Google-Smtp-Source: ABdhPJynlw/SBVQTFMqkSUafTkhVK8OLd0tcMIVyxIyT2yMTp1HrkCCth0effvKqfnZX1SEOld45dw==
X-Received: by 2002:a17:906:fb0e:: with SMTP id lz14mr28531282ejb.108.1639186658368;
        Fri, 10 Dec 2021 17:37:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id eg8sm2192903edb.75.2021.12.10.17.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 17:37:37 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <77dabd5d-b9aa-1fc7-b555-dae67dc6f272@redhat.com>
Date:   Sat, 11 Dec 2021 02:37:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Potential bug in TDP MMU
Content-Language: en-US
To:     Ignat Korchagin <ignat@cloudflare.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com>
 <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/21 00:04, Ignat Korchagin wrote:
> That is, I never get a stack with
> kvm_tdp_mmu_put_root->..->kvm_set_pfn_dirty with a "good" run.
> Perhaps, this may shed some light onto what is going on.

Maybe not kvm_tdp_mmu_put_root->...->kvm_set_pfn_dirty per se, but
do_exit->kvm_tdp_mmu_put_root->...->kvm_set_pfn_dirty seems to be
part of the problem.

Both kvm_set_pfn_dirty and kvm_set_pfn_accessed, which is where
execution really goes in the weeds, have this conditional:

	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
		...

And indeed kvm_is_zone_device_pfn(pfn) returns false if the WARN_ON_ONCE
fires.  What happens is that the page has already been released by the
process's exiting, so it has no A/D tracking anymore.  But the conditional
is true and bad things happen in workingset_activation: while
!page_count(pfn_to_page(pfn)) is definitely not a ZONE_DEVICE page,
it's _also_ not a page that should be marked dirty or accessed.

Something like the following, while completely wrong or at least nothing
more than a bandaid, should at least avoid the worst consequences of the
bug:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 168d0ab93c88..699455715699 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -176,6 +176,14 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
  	return is_zone_device_page(pfn_to_page(pfn));
  }
  
+static inline bool kvm_pfn_has_accessed_dirty(kvm_pfn_t pfn)
+{
+	if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))
+		return false;
+
+	return !PageReserved(pfn_to_page(pfn)) || is_zero_pfn(pfn);
+}
+
  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
  {
  	/*
@@ -2812,14 +2820,14 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
  
  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
  {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (kvm_pfn_has_accessed_dirty(pfn))
  		SetPageDirty(pfn_to_page(pfn));
  }
  EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
  
  void kvm_set_pfn_accessed(kvm_pfn_t pfn)
  {
-	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+	if (kvm_pfn_has_accessed_dirty(pfn))
  		mark_page_accessed(pfn_to_page(pfn));
  }
  EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);

The real question is why kvm_mmu_free_roots is finding some dirty pages
in the do_exit->exit_files->...->close_files path, well after exit_mm()
has finished running.  I'm not sure how kvm_mmu_zap_all could leave
something behind.

Th might be completely off track, but maybe it helps someone fixing
the bug while I get some sleep.

Paolo
