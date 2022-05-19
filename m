Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9698252DA5E
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbiESQhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiESQhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:37:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D860CD809B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:37:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c22so5568490pgu.2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F28DbulQ0jEkQGLikm8EqDCBfoSZOeUw515EvhneCFA=;
        b=mIZhrXQ4iFDgPsYFsZ60+OFftLbzg2tZW+uB4Ooe2VBWkW8cBXZysVagXo2RHoj2JB
         lB5PsP+r0vtw5PFYL7B5Y3KWrKTQz5GQdLa12HpSuDW1l8BJQScklN/B+swR9iP2becL
         eRKAYpFxwRMcG0SHKNoGGPgJxYRV9lyd62T7ErM9+iqtrSjZUFBFRxMcnzUY3VZ88IEl
         dM/9ug6NofL/hobVN6loSHRaQ19j9XqB1sHW50BI4yWVP3eobgOMPogH4GixJA/neC7R
         4W7l6Z6XIGmCOCHUYVm1JJfgNgrAyb903+W2X5UumWnHyOF6RUtPiBKwafzpWnNSbDqk
         JieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F28DbulQ0jEkQGLikm8EqDCBfoSZOeUw515EvhneCFA=;
        b=wGfkfi0sSVDMkILWQ+n682mONsMVsto3TAGvQOMFHNyXI9O85d7yKRrnHtNG4J2M8+
         nYRFzL8LYtg+pGt/e5PgUo8X0ktOFtZD5XFFBVy9jJXSq1xe7sDiOMMupw/U8dAFJ5Vw
         ywrmDjJGLK1H8bf1juvG520JyZco1ji/gyRzB680KQ4eKBJcT3ZLtnRlyhdULut8+uht
         GxMucP5+U5zO3UR+CSjoPjviabuN1EyBFK8aSrf+v/d4h+M4rleioXELEFIiQRFJzmnE
         /IDIjfE+8qMSHip5BKV8i31t/tQaDsGrQZ6TeFfOW/pztnw56KOe1IreiuYtqvdtVRXj
         QJLw==
X-Gm-Message-State: AOAM533IsLAtKK63if4y4P9r9N5FEcSC5R5fN6AjCA03/PxQU0YZTOEL
        4/kEkxaN+uAFnvVr+mexPuLvYg==
X-Google-Smtp-Source: ABdhPJx1nKZBsvM/1s0Knp+K6VPSacbbVwoq4r4yMLooMeqC6xBtrejZP6toBWYuM4j+VwQpyBM+WQ==
X-Received: by 2002:a63:d611:0:b0:3c6:afdf:819b with SMTP id q17-20020a63d611000000b003c6afdf819bmr4622740pgg.513.1652978269170;
        Thu, 19 May 2022 09:37:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b0015e8d4eb24dsm4023212pll.151.2022.05.19.09.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:37:48 -0700 (PDT)
Date:   Thu, 19 May 2022 16:37:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 04/19] KVM: x86: mmu: allow to enable write
 tracking externally
Message-ID: <YoZyWOh4NPA0uN5J@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427200314.276673-5-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> @@ -5753,6 +5752,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);

Can you add a patch to move this call to kvm_page_track_register_notifier() into
mmu_enable_write_tracking(), and simultaneously add a WARN in the register path
that page tracking is enabled?

Oh, actually, a better idea. Add an inner __kvm_page_track_register_notifier()
that is not exported and thus used only by KVM, invoke mmu_enable_write_tracking()
from the exported kvm_page_track_register_notifier(), and then do the above.
That will require modifying KVMGT and KVM in a single patch, but that's ok.

That will avoid any possibility of an external user failing to enabling tracking
before registering its notifier, and also avoids bikeshedding over what to do with
the one-line wrapper to enable tracking.
