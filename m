Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6FD4BC479
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 02:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240849AbiBSBOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 20:14:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238860AbiBSBOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 20:14:39 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766BA271E1A
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 17:14:21 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y16so1829327pjt.0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 17:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tNWd+wWGar29mUOw48ON5Yh80VoQ1A2pKkcRz5dua9I=;
        b=XfaRi5Uipc92Giqkwuq50vaTYmBhbz7LbE89SoQi4xd6WsE2KsofBfgbng2RUIvNl3
         ZlnC+GJJXEG/2kczDoeKD2Itr8u1JRbBL0BSazVKkYnnTw1I7HdduRuT7bk/7+XCvTGi
         YKBT5owTf+eNAm4mrqSzYRtOJ/Yfe46011FkVRZhlmE4j88zsjfNsPfwhi35LGu73wFu
         n/3hSeuhhVcP0xOYRy6HeNFr+fvmksWNaK0I/ppVw/iaDJ6fc45aJ3JE8edJ9S6bwATI
         cajx5/+yCO7GtUOhMKNEWzE43hOGivDAjpXV7wv0I6AfpYbibOohlCNhqzMgqEcxHldc
         Hy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tNWd+wWGar29mUOw48ON5Yh80VoQ1A2pKkcRz5dua9I=;
        b=otjufStXEo1cgGw3Ps5VEEm06i2AfYeilQAtOwfNAuqn0WysNPvmuVAyYbB4a4PtlU
         lQMOGXWev6Vrl243RK3yPIfqCQ2ZbdiVahxb/0Nh/vsCNxfMGcww30VcwpiV0iWm+gxZ
         Kl0qwWm6kcV3MdaiN8XtaAU1y92KlnMYWD/ktusGxyk94f+7uVDL7NJbiuGz7Sw1rncA
         0krKCrAUaUwAoxI77YcbfZ4D2YajuiMDGeJazLMRa1RiCBCUMNBlegzU2DjtuXaaExsB
         bHEZCadvCrTxqU8OiMIqIZBtLaeZZ313XfbvWLclp8lSXf4xFpb6oadIO12tMVC9xROF
         W96Q==
X-Gm-Message-State: AOAM533EwJCP6G+SNdC+ZCofNsvlBVsCtHkFt5w10OVMeaf8XaqzebCm
        HuBiL8a3xirQrSF2DxpbbaLiLw==
X-Google-Smtp-Source: ABdhPJxqL3rFprvL8txUeV4DPkuB8nfa8nvKJkBvy+RvYiT9ntyqlEPT5CfXvfyMArgTbLeaOn7vmA==
X-Received: by 2002:a17:90b:351:b0:1b8:cc31:6c42 with SMTP id fh17-20020a17090b035100b001b8cc316c42mr10876620pjb.27.1645233260748;
        Fri, 18 Feb 2022 17:14:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q21sm4315419pfu.188.2022.02.18.17.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 17:14:20 -0800 (PST)
Date:   Sat, 19 Feb 2022 01:14:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 02/23] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YhBEaPWDoBiTpNV3@google.com>
References: <20220203010051.2813563-1-dmatlack@google.com>
 <20220203010051.2813563-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220203010051.2813563-3-dmatlack@google.com>
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

On Thu, Feb 03, 2022, David Matlack wrote:
> Instead of computing the shadow page role from scratch for every new
> page, we can derive most of the information from the parent shadow page.
> This avoids redundant calculations such as the quadrant, and reduces the

Uh, calculating quadrant isn't redundant.  The quadrant forces KVM to use different
(multiple) shadow pages to shadow a single guest PTE when the guest is using 32-bit
paging (1024 PTEs per page table vs. 512 PTEs per page table).  The reason quadrant
is "quad" and not more or less is because 32-bit paging has two levels.  First-level
PTEs can have quadrant=0/1, and that gets doubled for second-level PTEs because we
need to use four PTEs (two to handle 2x guest PTEs, and each of those needs to be
unique for the first-level PTEs they point at).

Indeed, this fails spectacularly when attempting to boot a 32-bit non-PAE kernel
with shadow paging enabled.

 \���	���\���	��\���
 	P��\��`
 BUG: unable to handle page fault for address: ff9fa81c
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 *pde = 00000000
 ����
 Oops: 0000 [#1]��<���� SMP��<������<������<����
 ��<����CPU: 0 PID: 0 Comm: swapper ��<����G        W         5.12.0 #10
 ��<����EIP: memblock_add_range.isra.18.constprop.23d�r
 ��<����Code: <83> 79 04 00 75 2c 83 38 01 75 06 83 78 08 00 74 02 0f 0b 89 11 8b
 ��<����EAX: c2af24bc EBX: fdffffff ECX: ff9fa818 EDX: 02000000
 ��<����ESI: 02000000 EDI: 00000000 EBP: c2909f30 ESP: c2909f0c
 ��<����DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210006
 ��<����CR0: 80050033 CR2: ff9fa81c CR3: 02b76000 CR4: 00040600
 ��<����Call Trace:
 ��<���� ? printkd�r
 ��<���� ��<����memblock_reserved�r
 ��<���� ? 0xc2000000
 ��<���� ��<����setup_archd�r
 ��<���� ? vprintk_defaultd�r
 ��<���� ? vprintkd�r
 ��<���� ��<����start_kerneld�r
 ��<���� ��<����i386_start_kerneld�r
 ��<���� ��<����startup_32_smpd�r

 ����
 CR2: 00000000ff9fa81c

 ��<����EIP: memblock_add_range.isra.18.constprop.23d�r
 ��<����Code: <83> 79 04 00 75 2c 83 38 01 75 06 83 78 08 00 74 02 0f 0b 89 11 8b
 ��<����EAX: c2af24bc EBX: fdffffff ECX: ff9fa818 EDX: 02000000
 ��<����ESI: 02000000 EDI: 00000000 EBP: c2909f30 ESP: c2909f0c
 ��<����DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210006
 ��<����CR0: 80050033 CR2: ff9fa81c CR3: 02b76000 CR4: 00040600

> number of parameters to kvm_mmu_get_page().
> 
> Preemptivel split out the role calculation to a separate function for

Preemptively.

> use in a following commit.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
