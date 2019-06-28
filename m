Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BA459928
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 13:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfF1LXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 07:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbfF1LXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 07:23:46 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 478A63082B44;
        Fri, 28 Jun 2019 11:23:38 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDC135DA97;
        Fri, 28 Jun 2019 11:23:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 0/2] x86/kvm/nVMX: fix Enlightened VMCLEAR
Date:   Fri, 28 Jun 2019 13:23:31 +0200
Message-Id: <20190628112333.31165-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 28 Jun 2019 11:23:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCLEAR implementation for Enlightened VMCS is not entirely correct
when something else than the currently active eVMCS on the calling vCPU
is targeted. In case there's no currently active eVMCS on the calling vCPU
we are corrupting the targeted area by writing to the non-existent
launch_state field.

Fix the logic by always treating the targeted area as 'enlightened' in case
Enlightened VMEntry is enabled on the calling vCPU.

Changes since v1:
- 'evmcs_vmptr' -> 'evmcs_gpa' [Paolo Bonzini]
- avoid nested_release_evmcs() in handle_vmclear even for the currently
  active eVMCS on the calling vCPU [Liran Alon], PATCH1 added to support
  the change.

Vitaly Kuznetsov (2):
  x86/KVM/nVMX: don't use clean fields data on enlightened VMLAUNCH
  x86/kvm/nVMX: fix VMCLEAR when Enlightened VMCS is in use

 arch/x86/kvm/vmx/evmcs.c  | 18 ++++++++++++++
 arch/x86/kvm/vmx/evmcs.h  |  1 +
 arch/x86/kvm/vmx/nested.c | 52 ++++++++++++++++++++++-----------------
 3 files changed, 49 insertions(+), 22 deletions(-)

-- 
2.20.1

