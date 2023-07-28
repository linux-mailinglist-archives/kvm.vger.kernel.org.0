Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F93766A23
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 12:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjG1KWX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Jul 2023 06:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjG1KWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 06:22:15 -0400
X-Greylist: delayed 84 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Jul 2023 03:22:13 PDT
Received: from cmx-mtlrgo002.bell.net (mta-mtl-001.bell.net [209.71.208.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771D53A95
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 03:22:12 -0700 (PDT)
X-RG-CM-BuS: 0
X-RG-CM-SC: 0
X-RG-CM: Clean
X-Originating-IP: [74.15.145.5]
X-RG-Env-Sender: leclercnorm@sympatico.ca
X-RG-Rigid: 64C354070002CC1A
X-CM-Envelope: MS4xfEUPmodnFGssuDGoqVSmneltZnAOH0vFdXgCW42KEkLIj+/DWM4njUenYa/nLoKdP7vdAq1A6s3hg5KlEcXpU5sr6qLnFA0Z2MfUuLrYiK/Iy1gqhNvt
 pWVF9E4wTCHS2R1nSZQ8hYe3abYBnVAZxQ+zbZmpPA79jV/J014TaLRSvI7M8eXkLoQz65yjsPvA2w==
X-CM-Analysis: v=2.4 cv=QbcFAuXv c=1 sm=1 tr=0 ts=64c3967e
 a=vMtcqUOSM9xK0Dyo5NtYyw==:117 a=vMtcqUOSM9xK0Dyo5NtYyw==:17
 a=IkcTkHD0fZMA:10 a=WXBLPWtvbYal-QWfhY4A:9 a=QEXdDO2ut3YA:10
Received: from smtpclient.apple (74.15.145.5) by cmx-mtlrgo002.bell.net (5.8.814) (authenticated as leclercnorm@sympatico.ca)
        id 64C354070002CC1A for kvm@vger.kernel.org; Fri, 28 Jul 2023 06:20:46 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Normand Leclerc <leclercnorm@sympatico.ca>
Mime-Version: 1.0 (1.0)
Date:   Fri, 28 Jul 2023 06:20:36 -0400
Subject: KVM PCI Passthrough IRQ issues
Message-Id: <BA42560B-B6B1-44B6-994E-AA9B48E9F5E0@sympatico.ca>
To:     kvm@vger.kernel.org
X-Mailer: iPad Mail (20F75)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I have a CameraLink capture card of which I do not have Linux drivers.  I wanted to used it in Windows 11 under KVM.

I have managed to have the card recognized in the OS, installed drivers and the system does see the clock and data valid; great!  But this doesn’t happen without hickups; KVM has to be started twice.  The first time KVM starts, the driver tells me that there is not enough ressources for the API.

Even though the card seems to be working well, I cannot capture anything.  The software is not able to fully use the card.

The system is:
AMD Ryzen 7950x3d
ASROCK Steel Legend x670e
Teledyne XTIUM-CL MX4 (capture card)
Archlinux system (Linux omega 6.4.6-artix1-1 #1 SMP PREEMPT_DYNAMIC Wed, 26 Jul 2023 13:47:50 +0000 x86_64 GNU/Linux)

lspci after boot for the card:

01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
        Flags: fast devsel, IRQ 255, IOMMU group 12
        Memory at fb000000 (32-bit, non-prefetchable) [disabled] [size=16M]
        Capabilities: [80] Power Management version 3
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [c0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [300] Secondary PCI Express


After vfio driver assignment:

01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
        Flags: fast devsel, IRQ 255, IOMMU group 12
        Memory at fb000000 (32-bit, non-prefetchable) [disabled] [size=16M]
        Capabilities: [80] Power Management version 3
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [c0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [300] Secondary PCI Express
        Kernel driver in use: vfio-pci

Starting KVM first time (second time is the same):

01:00.0 Memory controller [0580]: Coreco Inc Device [11ec:f81b]
        Flags: fast devsel, IRQ 135, IOMMU group 12
        Memory at fb000000 (32-bit, non-prefetchable) [disabled] [size=16M]
        Capabilities: [80] Power Management version 3
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [c0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Device Serial Number 00-00-00-00-00-00-00-00
        Capabilities: [300] Secondary PCI Express
        Kernel driver in use: vfio-pci

First time KVM starts, lsirq does not show IRQ 135; second time, it does.

If kernel has not been started with irqpoll, I get the infamous “nobody cared” message and irq135 gets disabled.  Running kernel with irqpoll, lsirq shows a whole bunch on interrupts (probably at each frame the grabber sees).

It is as if the interrupt assigned to the card is not what KVM is using to pass down to the guest Windows machine.  The interrupt does not get to the capture card’s software and it fails.

I seek help to resolve this issue.

Best,
Norm

Sent from my ENIAC
