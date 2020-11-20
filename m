Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF72BAA9F
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 13:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgKTM44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 07:56:56 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50174 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgKTM4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 07:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605877015; x=1637413015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ceMWn8T0CAbjITH4HkGnzvZ7dokgaqs2qfmig/tZCQk=;
  b=bG7qJjH3g5PXpkAjG027lYbrDevtounJ22utoyeja6JXJ6U+yWk1r3D0
   NB495EVZjIcM1BvXuCj7LvvZ8cfo/gddxUDFCKunua0dst1B5XPyKhhK2
   gQNYn8V44BG96TWFyImaD1EKBR4CXrQ//auf9hGu7l+wFAhXlUh/bkK5I
   U=;
X-IronPort-AV: E=Sophos;i="5.78,356,1599523200"; 
   d="scan'208";a="65113057"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 20 Nov 2020 12:56:54 +0000
Received: from EX13D50EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 0D9E5240C32;
        Fri, 20 Nov 2020 12:56:50 +0000 (UTC)
Received: from EX13D52EUA002.ant.amazon.com (10.43.165.139) by
 EX13D50EUA002.ant.amazon.com (10.43.165.201) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:56:49 +0000
Received: from uc995cb558fb65a.ant.amazon.com (10.43.162.50) by
 EX13D52EUA002.ant.amazon.com (10.43.165.139) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 20 Nov 2020 12:56:44 +0000
From:   <darkhan@amazon.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <corbet@lwn.net>, <maz@kernel.org>,
        <james.morse@arm.com>, <catalin.marinas@arm.com>,
        <chenhc@lemote.com>, <paulus@ozlabs.org>, <frankja@linux.ibm.com>,
        <mingo@redhat.com>, <acme@redhat.com>, <graf@amazon.de>,
        <darkhan@amazon.de>, Darkhan Mukashov <darkhan@amazon.com>
Subject: [PATCH 1/3] Documentation: KVM: change description of vcpu ioctls KVM_(GET|SET)_ONE_REG
Date:   Fri, 20 Nov 2020 13:56:14 +0100
Message-ID: <20201120125616.14436-2-darkhan@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120125616.14436-1-darkhan@amazon.com>
References: <20201120125616.14436-1-darkhan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D32UWB001.ant.amazon.com (10.43.161.248) To
 EX13D52EUA002.ant.amazon.com (10.43.165.139)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Darkhan Mukashov <darkhan@amazon.com>

KVM APIs KVM_GET_ONE_REG and KVM_SET_ONE_REG are not implemented
in x86. They are handled in architecture specific "kvm_arch_vcpu_ioctl"
functions. There are no handlers for KVM_GET_ONE_REG and KVM_SET_ONE_REG
in "kvm_arch_vcpu_ioctl" in x86. -EINVAL is returned when both are called.
Therefore, architectures supported by KVM_(GET|SET)_ONE_REG should be
"all except x86" rather than "all".

KVM_GET_ONE_REG accepts a struct kvm_one_reg and writes value of a register
indicated by 'id' field of the struct to the memory location pointed by
'addr' field of the struct. As nothing is written to the struct
kvm_one_reg, parameter type should be "in" rather than "in/out".

Signed-off-by: Darkhan Mukashov <darkhan@amazon.com>
---
 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 76317221d29f..6d6135c15729 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2105,7 +2105,7 @@ prior to calling the KVM_RUN ioctl.
 --------------------
 
 :Capability: KVM_CAP_ONE_REG
-:Architectures: all
+:Architectures: all except x86
 :Type: vcpu ioctl
 :Parameters: struct kvm_one_reg (in)
 :Returns: 0 on success, negative value on failure
@@ -2544,9 +2544,9 @@ following id bit patterns::
 --------------------
 
 :Capability: KVM_CAP_ONE_REG
-:Architectures: all
+:Architectures: all except x86
 :Type: vcpu ioctl
-:Parameters: struct kvm_one_reg (in and out)
+:Parameters: struct kvm_one_reg (in)
 :Returns: 0 on success, negative value on failure
 
 Errors include:
-- 
2.17.1

