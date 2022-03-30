Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0C84EC57E
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 15:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345893AbiC3NXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 09:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345921AbiC3NWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 09:22:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF234924F;
        Wed, 30 Mar 2022 06:21:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso2114014pjb.0;
        Wed, 30 Mar 2022 06:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OPJfz4CL4CTD8umiB0QsWWK1NVmdwE13zEumGoQ0BuI=;
        b=RdznN1wmQ7YkABgZinX6FM9J7ZRfZrnPXFREURoNQM/325oFnFddsMhY+7l5bzmw6T
         S5TziyTyhp+HilrOWzp65Rr2HBmeRO6z84JIgqyZFd3FTYYlVfaQucjbqRD9eyVkH6iM
         va+ELz1AoQ5xCOX2BdLgZ3zOGSsEoTrX30hTtMQXpsb7jMZiiGbLuPSfd/GzHzQ6BWiG
         etoIlN4Hr1PLahVVgbyB7lzpIYciImI8CcxRj7mQYI+rfRacvEjDPrfTstu+eb00mKWQ
         W78SxhWBokJI15m32Ijc1p2JE+SbZBBxc35I6l4SFbiRaSKzUmrKFKm6fRrrge/kQsZQ
         7+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OPJfz4CL4CTD8umiB0QsWWK1NVmdwE13zEumGoQ0BuI=;
        b=SrgJAIVZVx9OYYqj35yB2HoW2BAo/QG7UGKDrS8/2Xw469moMUinx8Wo6OtW0hd+jI
         /hDRiMHkcFnVTrNHcln5PGdRaHg57ts4teF50Hfs4KQMECe4pNPUagRosCSxrU1YuzVI
         rAbWmSNGvWWqtH3xdBU++KCcoyr4T/hqrCFfmFuBlVa/pinm4aZhcQjRC1+G9MuCayby
         5EtjfILjTREraEdTD98iyRw3TvPVhQ68WZAcnWE0fTquQNjyQfGrejJ2X/4RfT+9ZGqC
         dQIHs+H11pexQwBUzGtNC4V/Szx5GOSE+Ea5Vn4jiRClzDP/+/WG6TN7xSr8OALtfdJl
         UCag==
X-Gm-Message-State: AOAM533z9WaXyEQpzgVyB8LNkZyXFwnb9dluAqEHtBe6zxU7S3BJWZyO
        IaGq6mwqmChtpAuPK9z9EndOTM3bzs8=
X-Google-Smtp-Source: ABdhPJy8sCfixj5+rlePqk9kImJ3wC4G6RlmXO/xOHhD5a3zdm82DdY6eBXESJVS6LTln7jAqjcJ7Q==
X-Received: by 2002:a17:902:bf4a:b0:151:7d37:2943 with SMTP id u10-20020a170902bf4a00b001517d372943mr35075780pls.131.1648646467456;
        Wed, 30 Mar 2022 06:21:07 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id f66-20020a62db45000000b004fa8a7b8ad3sm23004668pfg.77.2022.03.30.06.21.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Mar 2022 06:21:07 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [RFC PATCH V3 0/4] KVM: X86: Add and use shadow page with level expanded or acting as pae_root
Date:   Wed, 30 Mar 2022 21:21:48 +0800
Message-Id: <20220330132152.4568-1-jiangshanlai@gmail.com>
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
role.pae_root and role.glevel code with only 8 line of code is
added for shadow-NPT, only 2 line of code is not covered in my tests).

Cleanup patches (such as use role.glevel instead of !role.direct) will
be sent after this patchset is queued.

[V2]: https://lore.kernel.org/lkml/20220329153604.507475-1-jiangshanlai@gmail.com/
[V1]: https://lore.kernel.org/lkml/20211210092508.7185-1-jiangshanlai@gmail.com/

Changed from V2:
	Instroduce role.glevel instead of role.passthrough

Changed from V1:
	Apply Sean's comments and suggestion. (Too much to list. Thanks!)
	Add some comments.
	Change changelog for role.pae_root patch.

Lai Jiangshan (4):
  KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
  KVM: X86: Introduce role.glevel for level expanded pagetable
  KVM: X86: Alloc role.pae_root shadow page
  KVM: X86: Use passthrough and pae_root shadow page for 32bit guests

 Documentation/virt/kvm/mmu.rst  |   9 +
 arch/x86/include/asm/kvm_host.h |  16 +-
 arch/x86/kvm/mmu/mmu.c          | 399 +++++++++-----------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  15 +-
 4 files changed, 138 insertions(+), 301 deletions(-)

-- 
2.19.1.6.gb485710b

