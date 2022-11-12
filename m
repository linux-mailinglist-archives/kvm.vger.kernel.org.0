Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD13A626610
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 01:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiKLAnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 19:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiKLAnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 19:43:13 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9D976FBA
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 16:43:12 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z26so6232500pff.1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 16:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/69SGTblteqzTGqi+tKsPG0LW4tOtiDqnrFyQWptaQ=;
        b=nkkHJRYG9RSNUubkLNubrJI/d3KOEidZrgmUPThr3GFsr7fra6VsI+pb1qqQQ02WKX
         zF1WmMPVXJP4zWYv5H2yrK2XmJWXLyIYGleBrctfrNS+0hqbbCZ/iqh9/fdMvnZajEwa
         S7yTODLsbBcMwXwbemvi9xcCSHrHJ12nb+aTQowsorgnzkj19FB9Krp7KBYJxZyP21EO
         7pIoX7pjC6wc+oSETXDUqR/kq2X+LicMr3aKFzkyce/50iVQxoQgCThUjuJ/3KLMl8+B
         z6LnADkM+0e/zYQoLtoBvelqEGFYq3NJyiIEmKpY5AR6UOQqXPItQJPmeuPg0YF/+hoh
         Qb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/69SGTblteqzTGqi+tKsPG0LW4tOtiDqnrFyQWptaQ=;
        b=4ZklvRWuxpIfLTWcI/aTziLZ+xRJnIp0ass0IVYygRh82cG3vBFC2dRZg8mMHhaebF
         1duse+QwXMpO0xL0u9e6ObXVsqa/AXD9qnhGriWh1Lc0PoBnCAE1XId9r3jqXaCk1J0E
         H335hyrVHn497ZYGvh+etTNCL+c03ICe9SoF5nWzCq4lk+eWcF39twdQ+1rLY6au00WC
         SRtZO/tjIxEUTwayleI8hVJLIv5pIDIJIB4x214xqpdzAlVvXcTCeZIXS9n4z7ZL2Z7w
         HkUl60F5CNdNyxC93bnhAS5VxIpmc21J79hemeUTmWjv9QQsQyWFL4EHZj9DpAob2pER
         DLbQ==
X-Gm-Message-State: ANoB5pl6AFVGwo9EceFEImNiSl1v8XvOD3LH+z8dM5Gg9XdL24hg0Yr+
        7VpdlpO21S6VGIJgzNIk6MvAEhxE32y25w==
X-Google-Smtp-Source: AA0mqf4WsOfrQhaQruL4asl5Iu86noh/aH6GkJDdmp/AzA4oKTD7iRzggslPFH8j54SEF3nTst7kQA==
X-Received: by 2002:a62:838f:0:b0:56c:8b7:f2dc with SMTP id h137-20020a62838f000000b0056c08b7f2dcmr5095877pfe.16.1668213791697;
        Fri, 11 Nov 2022 16:43:11 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o127-20020a625a85000000b0056bc9294e1asm2154927pfb.24.2022.11.11.16.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 16:43:11 -0800 (PST)
Date:   Sat, 12 Nov 2022 00:43:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y27sG3AqVX8yLUgR@google.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 12, 2022, Yan Zhao wrote:
> And I'm also not sure if a slots_arch_lock is required for
> kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().

It's not required.  slots_arch_lock protects interaction between memslot updates
mmu_first_shadow_root_alloc().  When CONFIG_KVM_EXTERNAL_WRITE_TRACKING=y, then
the mmu_first_shadow_root_alloc() doesn't touch the memslots because everything
is pre-allocated:

bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
{
	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
}

int kvm_page_track_create_memslot(struct kvm *kvm,
				  struct kvm_memory_slot *slot,
				  unsigned long npages)
{
	if (!kvm_page_track_write_tracking_enabled(kvm)) <== always true
		return 0;

	return __kvm_page_track_write_tracking_alloc(slot, npages);
}

Though now that you point it out, it's tempting to #ifdef out some of those hooks
so that's basically impossible for mmu_first_shadow_root_alloc() to cause problems.
Not sure the extra #ideffery would be worth while though.

slots_arch_lock also protects shadow_root_allocated, but that's a KVM-internal
detail that isn't relevant to the page-tracking machinery when
CONFIG_KVM_EXTERNAL_WRITE_TRACKING=y.
