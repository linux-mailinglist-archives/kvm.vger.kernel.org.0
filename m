Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D847C585519
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiG2Sqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiG2Sqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 14:46:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD085A8A0
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:46:46 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q14so4280814iod.3
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Fnhyk5gLFQEwsJhfQYKuwr0cjl/8dz+duvFdwzZkUrE=;
        b=gxVP8cku9Bw1/VU8BYM/gHmgG3lEBkfgDP93zh0zKLMTbWMqzPrYCfj+fNQsA5orbo
         O2/mTPnA3HyB8P5tlxTZAnt+jt3HodpVnblz7ElhSNACk7FqH/YZd1EsrH3qSPpipY/m
         XNKkiTjdBGN2L0VknqC/N0B1jprRg3Rjbrl1OCvfByDP+tLcCaCPiFG0sWD2XUpgwDM3
         mZvKoHnCLrB0BEKJdopm6NMyAv4e0qdpnpCvTT3cuyjEhfwk19BKPRoGUcw+v+NM50nJ
         MENh/WxL/H66rJytORM1E01INuM8BxTIL64LLhbNlI0kLL1bejixa1ypi/u9iXsCjPKl
         Y/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Fnhyk5gLFQEwsJhfQYKuwr0cjl/8dz+duvFdwzZkUrE=;
        b=pe50hxt326YbPgu/u6hR91MTLbTeuQz64MuTXFnmOg2iWcGYMd4q2m2EqpV6BMwMNJ
         mvw883km38aZkl5J3iCtOpIEJyQ8N0iSfaEVcMOhqMm/zJVOMj+joxSnEhnBlfT0SLcN
         91HNGFdUq15QVOicPLk86ba90wurLAYt5a5DUzGgWR9u48FkzDPq+8aXZJ/Jq/VbsdtB
         GPjc+Gk/ScP8P1bHBnGnJ4S8NP+3gA8WfPQZkJH8XErzFw3fdrjVlmVCApH4tKkxQASR
         rnC8Vc1OKn9Gv7apw7fmh362DwPey+G3XlupS//MXzj4QJanOcf68JVDC9oQGeGHlD64
         DBRw==
X-Gm-Message-State: AJIora+BretoYAIq5vtUUlMXXAKhMvP0j2OztqGMnoVnBVsua0O4eh/G
        LKj/5SI2tlf/0/dFIjpI+bftX0Zab1fPci3v
X-Google-Smtp-Source: AGRyM1s9okV2pRWA3Fcsyvo+i/vocs80/XI5TSLntOxAZW8EwS7EcF/KQ5/7BOYxMZYbswazU+GPcg==
X-Received: by 2002:a6b:c505:0:b0:67c:dcd:a5b2 with SMTP id v5-20020a6bc505000000b0067c0dcda5b2mr1607779iof.37.1659120406280;
        Fri, 29 Jul 2022 11:46:46 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id g14-20020a05663810ee00b003423f7b779csm1206576jae.41.2022.07.29.11.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 11:46:46 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     kvm@vger.kernel.org
Cc:     Coleman Dietsch <dietschc@csp.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2 0/2] KVM: x86/xen: Prevent xen timer init when running
Date:   Fri, 29 Jul 2022 13:46:38 -0500
Message-Id: <20220729184640.244969-1-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series was created to address the following bug found by syzbot
WARNING: ODEBUG bug in kvm_xen_vcpu_set_attr.

When running the syzbot reproducer code, the following crash dump occurs:

ODEBUG: init active (active state 0)
object type: hrtimer hint: xen_timer_callbac0
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Call Trace:
__debug_object_init
debug_hrtimer_init
debug_init
hrtimer_init
kvm_xen_init_timer
kvm_xen_vcpu_set_attr
kvm_arch_vcpu_ioctl
kvm_vcpu_ioctl
vfs_ioctl

The ODEBUG bug crash appears to be happening when vcpu->arch.xen.timer is
already set and kvm_xen_init_timer() is called, which appears to be the
result of two separate issues.

The first issue is that kvm_xen_init_timer() is run "every"
KVM_XEN_VCPU_ATTR_TYPE_TIMER. This is addressed in patch 1.

The second issue is that the stop xen timer code should be run before
changing the IRQ vector. This is addressed in patch 2 with some cleanup.

version 2 changes (mostly feedback from Sean Christopherson)
-split patch into 2 patches
-fix changelogs to be more descriptive
-fix formatting issues
-add check for existing xen timer before trying to initialize another one
-removed conditional for kvm_xen_stop_timer() so that it always runs
-ensure that xen timer is stopped before changing IRQ vector
-streamlined switch case KVM_XEN_VCPU_ATTR_TYPE_TIMER a bit

Coleman Dietsch (2):
  KVM: x86/xen: Initialize Xen timer only once
  KVM: x86/xen: Stop Xen timer before changing the IRQ vector

 arch/x86/kvm/xen.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

-- 
2.34.1

