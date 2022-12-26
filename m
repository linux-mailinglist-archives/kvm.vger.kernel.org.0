Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6565656260
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 13:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiLZMDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 07:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiLZMDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 07:03:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E3E6305
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 04:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8jqRLM34koGyVlHrDny51SpzLUhC6Xh1sZI5SeK/rHE=; b=Kw5tg/vIuX1I2OkHHucG+Qk79a
        Z4/RmQAeOttFrtihzLizUJRJzJXB6y4tZnOnZimoV7jmSnFginIX992P+jzUbUj3z62Y6/4kh6qHi
        0Mdxd8jsOBoKcggMc3RNDXHd+aoqiJ87eBZGjDwO9mPtmIjtoCY82X4ur0zZyROkq1sjpC1CxJT73
        jIcETSZ3j4eq/mwkr1j6sfZXfW6S5I4YQyZL1ypENatF5c2mDLHG+c9u7DSdtn4s3jX9ogunobPsS
        RU+N5rbWRMMAnQwqyMfIbIRY52+xyhAN0Epxre7A0I0dwAsYdvyNuf20sH4V9dt8IEJRRCUV9lMch
        qSTZHkDA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p9mCM-00FJcP-1O;
        Mon, 26 Dec 2022 12:03:19 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCO-004im2-RW; Mon, 26 Dec 2022 12:03:20 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 6/6] KVM: x86/xen: Documentation updates and clarifications
Date:   Mon, 26 Dec 2022 12:03:20 +0000
Message-Id: <20221226120320.1125390-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221226120320.1125390-1-dwmw2@infradead.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
 <20221226120320.1125390-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Most notably, the KVM_XEN_EVTCHN_RESET feature had escaped documentation
entirely. Along with how to turn most stuff off on SHUTDOWN_soft_reset.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst | 41 +++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d795d683601c..af6471657395 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5343,9 +5343,9 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
   32 vCPUs in the shared_info page, KVM does not automatically do so
   and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
   explicitly even when the vcpu_info for a given vCPU resides at the
-  "default" location in the shared_info page. This is because KVM is
-  not aware of the Xen CPU id which is used as the index into the
-  vcpu_info[] array, so cannot know the correct default location.
+  "default" location in the shared_info page. This is because KVM may
+  not be aware of the Xen CPU id which is used as the index into the
+  vcpu_info[] array, so may know the correct default location.
 
   Note that the shared info page may be constantly written to by KVM;
   it contains the event channel bitmap used to deliver interrupts to
@@ -5356,23 +5356,29 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
   any vCPU has been running or any event channel interrupts can be
   routed to the guest.
 
+  Setting the gfn to KVM_XEN_INVALID_GFN will disable the shared info
+  page.
+
 KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
   Sets the exception vector used to deliver Xen event channel upcalls.
   This is the HVM-wide vector injected directly by the hypervisor
   (not through the local APIC), typically configured by a guest via
-  HVM_PARAM_CALLBACK_IRQ.
+  HVM_PARAM_CALLBACK_IRQ. This can be disabled again (e.g. for guest
+  SHUTDOWN_soft_reset) by setting it to zero.
 
 KVM_XEN_ATTR_TYPE_EVTCHN
   This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
   support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It configures
   an outbound port number for interception of EVTCHNOP_send requests
-  from the guest. A given sending port number may be directed back
-  to a specified vCPU (by APIC ID) / port / priority on the guest,
-  or to trigger events on an eventfd. The vCPU and priority can be
-  changed by setting KVM_XEN_EVTCHN_UPDATE in a subsequent call,
-  but other fields cannot change for a given sending port. A port
-  mapping is removed by using KVM_XEN_EVTCHN_DEASSIGN in the flags
-  field.
+  from the guest. A given sending port number may be directed back to
+  a specified vCPU (by APIC ID) / port / priority on the guest, or to
+  trigger events on an eventfd. The vCPU and priority can be changed
+  by setting KVM_XEN_EVTCHN_UPDATE in a subsequent call, but but other
+  fields cannot change for a given sending port. A port mapping is
+  removed by using KVM_XEN_EVTCHN_DEASSIGN in the flags field. Passing
+  KVM_XEN_EVTCHN_RESET in the flags field removes all interception of
+  outbound event channels. The values of the flags field are mutually
+  exclusive and cannot be combined as a bitmask.
 
 KVM_XEN_ATTR_TYPE_XEN_VERSION
   This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
@@ -5388,7 +5394,7 @@ KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG
   support for KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG. It enables the
   XEN_RUNSTATE_UPDATE flag which allows guest vCPUs to safely read
   other vCPUs' vcpu_runstate_info. Xen guests enable this feature via
-  the VM_ASST_TYPE_runstate_update_flag of the HYPERVISOR_vm_assist
+  the VMASST_TYPE_runstate_update_flag of the HYPERVISOR_vm_assist
   hypercall.
 
 4.127 KVM_XEN_HVM_GET_ATTR
@@ -5446,15 +5452,18 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
   As with the shared_info page for the VM, the corresponding page may be
   dirtied at any time if event channel interrupt delivery is enabled, so
   userspace should always assume that the page is dirty without relying
-  on dirty logging.
+  on dirty logging. Setting the gpa to KVM_XEN_INVALID_GPA will disable
+  the vcpu_info.
 
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
   for a given vCPU. This is typically used for guest vsyscall support.
+  Setting the gpa to KVM_XEN_INVALID_GPA will disable the structure.
 
 KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR
   Sets the guest physical address of the vcpu_runstate_info for a given
   vCPU. This is how a Xen guest tracks CPU state such as steal time.
+  Setting the gpa to KVM_XEN_INVALID_GPA will disable the runstate area.
 
 KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT
   Sets the runstate (RUNSTATE_running/_runnable/_blocked/_offline) of
@@ -5487,7 +5496,8 @@ KVM_XEN_VCPU_ATTR_TYPE_TIMER
   This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
   support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It sets the
   event channel port/priority for the VIRQ_TIMER of the vCPU, as well
-  as allowing a pending timer to be saved/restored.
+  as allowing a pending timer to be saved/restored. Setting the timer
+  port to zero disables kernel handling of the singleshot timer.
 
 KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR
   This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
@@ -5495,7 +5505,8 @@ KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR
   per-vCPU local APIC upcall vector, configured by a Xen guest with
   the HVMOP_set_evtchn_upcall_vector hypercall. This is typically
   used by Windows guests, and is distinct from the HVM-wide upcall
-  vector configured with HVM_PARAM_CALLBACK_IRQ.
+  vector configured with HVM_PARAM_CALLBACK_IRQ. It is disabled by
+  setting the vector to zero.
 
 
 4.129 KVM_XEN_VCPU_GET_ATTR
-- 
2.35.3

