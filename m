Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DDB471646
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 21:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhLKUt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 15:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhLKUt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 15:49:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A02C061714
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 12:49:58 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w1so40064155edc.6
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 12:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BP9ZGqeXhmc9eyUy5AZsPasx6sUiVWitwnHwoMRz7+g=;
        b=jJQxP6UqAlHTLXohaJwC88yyd7+0dPAaMObV/aB6SEB/Bx4KNaYpbGVORyrIlykYiT
         3rEr9m8ldvys14k0pqd+pPjXmcdM3LZP9hjCjA8vy60ZIdYAesxb9vZLa63jtpFYvcau
         bpLoUGgwOFy2yd6WRXfVkeW3ZXjXtlRfzBg+CnCjOUIJQS8beIX/rtDw9IfjMYIBOOUb
         eOeVIyNnQRK9vSO2MHCa1oweyRK/EBt1siXrtBgmilnfmgltBsLG368+6h+UnhhH6p/J
         dDFGEP38RFRvN/9BdywZrvYCHHVSDKN9v4qxvijC8yRXxHFaUZLtLX7SvIgLkz+JCQhK
         Z6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BP9ZGqeXhmc9eyUy5AZsPasx6sUiVWitwnHwoMRz7+g=;
        b=8Q3zgjUyxdcH9F0RnLKfd5zMUY5PKX77xQPJu5+FTbyG6j/LcQ1BCRdZn7UtbLEl/V
         g70JblFtEloNlVN20A45cDAN96Xc42BPEL7lrx0rsIHeJgr0jh8oeey7/3fbwMM/fSW0
         8aoIHSexsRa5ypYOhXWSsoP13jr0ws7Z4C0u5UhwDK4KApkeEIKH3VSRzAM2YJh9bdLG
         9EWR97Epu2t84NfGMJU+EVXu8YIhYUrn3gxJ27LbzUuDiLpLZ/RoT7Zz4SwcGzu8tEfj
         y3vPysqH6JFwEX4KkjSqqY0YUyCrHgCEMKCOiIqJchZtptlErhgLb0PPfwUuVu4rSSr6
         Arqg==
X-Gm-Message-State: AOAM530CUkgdxVTtslTgm28V0aCo0yF7LgOkA/DfthdyXSYSUQNEFGPw
        prqry8/mRAp7v9iVpkyvgO8=
X-Google-Smtp-Source: ABdhPJw0b92VPdJYEk30KSugmsdBxflFAcekoF/eZhwxI3Ookvl/r17MjgYolCStwI1HzNk2LlfLsw==
X-Received: by 2002:a17:907:16ac:: with SMTP id hc44mr31944084ejc.363.1639255797403;
        Sat, 11 Dec 2021 12:49:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id cw20sm3511917ejc.90.2021.12.11.12.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 12:49:56 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <501ebf09-dee3-6394-cda7-bf94c7b55695@redhat.com>
Date:   Sat, 11 Dec 2021 21:49:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Potential bug in TDP MMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com>
 <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
 <YbQPcsnpowmCP7G8@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbQPcsnpowmCP7G8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/21 03:39, Sean Christopherson wrote:
> That means that KVM (a) is somehow losing track of a root, (b) isn't zapping all
> SPTEs in kvm_mmu_zap_all(), or (c) is installing a SPTE after the mm has been released.
> 
> (a) is unlikely because kvm_tdp_mmu_get_vcpu_root_hpa() is the only way for a
> vCPU to get a reference, and it holds mmu_lock for write, doesn't yield, and
> either gets a root from the list or adds a root to the list.
> 
> (b) is unlikely because I would expect the fallout to be much larger and not
> unique to your setup.

Hmm, I think it's kvm_mmu_zap_all() skipping invalidated roots.  One fix
could be the following - untested and uncompiled, after all it's Saturday.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..2e05b6a815b6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -781,18 +781,6 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
  	return flush;
  }
  
-void kvm_tdp_mmu_zap_all(struct kvm *kvm)
-{
-	bool flush = false;
-	int i;
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
-}
-
  static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  						  struct kvm_mmu_page *prev_root)
  {
@@ -859,6 +847,33 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  		kvm_flush_remote_tlbs(kvm);
  }
  
+void kvm_tdp_mmu_zap_all(struct kvm *kvm)
+{
+	struct kvm_mmu_page *root, *next_root;
+	bool flush = false;
+
+	/*
+	 * We need to zap all roots, including already-invalid ones.  The
+	 * easiest way is to ensure there's only invalid roots which then,
+	 * for efficiency, we zap with shared==false unlike
+	 * kvm_tdp_mmu_zap_invalidated_roots.
+	 */
+	kvm_tdp_mmu_invalidate_all_roots(kvm);
+
+	root = next_invalidated_root(kvm, NULL);
+	while (root) {
+		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, false);
+		next_root = next_invalidated_root(kvm, root);
+
+		/* Put the reference acquired in kvm_tdp_mmu_invalidate_roots.  */
+		kvm_tdp_mmu_put_root(kvm, root, false);
+		root = next_root;
+	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+}
+
  /*
   * Mark each TDP MMU root as invalid so that other threads
   * will drop their references and allow the root count to


Paolo
