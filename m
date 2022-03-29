Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622564EB0CF
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 17:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbiC2PhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 11:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238775AbiC2PhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 11:37:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EFE108557;
        Tue, 29 Mar 2022 08:35:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y6so15425003plg.2;
        Tue, 29 Mar 2022 08:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hXXDAsVberZERpiqBZUmvRldgBLnXTkqn777k+qHy4M=;
        b=EAI87mx8MDRK8xMXQNaElYaVk5+kOjZwSRg0qmZhjJvyEtzYi5sj8ZVsQzpF3jYH7E
         0PpQzdUEfa7xfxiTAtz+TmaLS9UvmI2vxlRHvcPeMjdy4tUw1d0vukOHfYp4J42xxJJf
         VH61yfGoH1H7NLWvCp82IdFZejvh+FS6ANiW8uehWkpvoCxXzkabUonIarc9ARo3F/aH
         4gemyU8oMXKtUYSuSGoL7JREfxm3SxGYqRviRTBBqh8Ro/HI6BUU+P/eiayBi2laq7pn
         Z5iKQr9DPzNUEQ9kzoDOv0GO1so+6U1iw/oDDQtCYZ90d0O25Jw771ASIihAULa6/BwU
         5Mgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hXXDAsVberZERpiqBZUmvRldgBLnXTkqn777k+qHy4M=;
        b=W9HD5efWPZdXr60gj3yiCrT5REvWnMXunOCvHvSqoXC6A8aUIUKVvTlitNZIjmW3HQ
         TqbZvkc5Cx3s25On1kUVFooFcc6aHXK21PsYSV1b9pSHfIYkYNwGSVdPhQZnbq4hkE39
         Lnm1WpdRY1qHf/8O1gQTwkxuR9uRY32yAQOb8dUee7qn1Bue3j69LGR/1JCMSfJVCopw
         v57VdGa425QF0aQ4srf/+ELzfnLdV/fdq/kubEY9dLGMwn5Db7O9v3e8drjAkBdO0Yii
         hzR8O3t7f9Qwwr4rlrVAG5N5GEVJFs+0NaaRAcsjkjnKiwmSYYqejzVhgIQLBxDqe2hr
         /g2g==
X-Gm-Message-State: AOAM533NC2ve52/RnkGd0/PBrehhBIy+3K4S9x0Yl6mZxuAv/FW0lMbQ
        GTceD9EO5eK0QUVQ/UFjWAaQAH/gK/E=
X-Google-Smtp-Source: ABdhPJwLcsla511HPCq1O4W/HZJVKhb6M0IsTGvQX7oPVlOP3QJPE75EqnWX9k9z0OTuejGHdavSZA==
X-Received: by 2002:a17:902:ea92:b0:153:d046:5711 with SMTP id x18-20020a170902ea9200b00153d0465711mr31245213plb.77.1648568123323;
        Tue, 29 Mar 2022 08:35:23 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm19292309pfm.207.2022.03.29.08.35.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Mar 2022 08:35:23 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [RFC PATCH V2 0/4] KVM: X86: Add and use shadow page with level expanded or acting as pae_root
Date:   Tue, 29 Mar 2022 23:36:00 +0800
Message-Id: <20220329153604.507475-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

(Request For Help for testing on AMD machine with 32 bit L1 hypervisor,
see information below)

KVM handles root pages specially for these cases:

direct mmu (nonpaping for 32 bit guest):
	gCR0_PG=0
shadow mmu (shadow paping for 32 bit guest):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1
direct mmu (NPT for 32bit host):
	hEFER_LMA=0
shadow nested NPT (for 32bit L1 hypervisor):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1,hEFER_LMA=0
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE={0|1},hEFER_LMA=1,hCR4_LA57={0|1}
Shadow nested NPT for 64bit L1 hypervisor:
	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1

They are either using special roots or matched the condition 
((mmu->shadow_root_level > mmu->root_level) && !mm->direct_map)
(refered as level expansion) or both.

All the cases are using special roots except the last one.
Many cases are doing level expansion including the last one.

When special roots are used, the root page will not be backed by
kvm_mmu_page.  So they must be treated specially, but not all places
is considering this problem, and Sean is adding some code to check
this special roots.

When level expansion, the kvm treats them silently always.

These treaments incur problems or complication, see the changelog
of every patch.

These patches were made when I reviewed all the usage of shadow_root_level
and root_level.  Many root level patches are sent and accepted.

These patches has not been tested with shadow NPT cases listed above.
Because I don't have guest images can act as 32 bit L1 hypervisor, nor
I can access to AMD machine with 5 level paging.  I'm a bit reluctant
to ask for the resource, so I send the patches and wish someone test
them and modify them.  At least, it provides some thinking and reveals
problems of the existing code and of the AMD cases.
( *Request For Help* here.)

These patches have been tested with the all cases except the shadow-NPT
cases, the code coverage is believed to be more than 95% (hundreds of
code related to shadow-NPT are shoved, and be replaced with common
role.pae_root and role.passthrough code with only 8 line of code is
added for shadow-NPT, only 2 line of code is not covered in my tests).

[V1]: https://lore.kernel.org/lkml/20211210092508.7185-1-jiangshanlai@gmail.com/

Changed from V1:
	Apply Sean's comments and suggestion. (Too much to list. Thanks!)
	Add some comments.
	Change changelog for role.pae_root patch.

Lai Jiangshan (4):
  KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
  KVM: X86: Introduce role.passthrough for level expanded pagetable
  KVM: X86: Alloc role.pae_root shadow page
  KVM: X86: Use passthrough and pae_root shadow page for 32bit guests

 Documentation/virt/kvm/mmu.rst  |   7 +
 arch/x86/include/asm/kvm_host.h |  16 +-
 arch/x86/kvm/mmu/mmu.c          | 400 +++++++++-----------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  15 +-
 4 files changed, 138 insertions(+), 300 deletions(-)

-- 
2.19.1.6.gb485710b

