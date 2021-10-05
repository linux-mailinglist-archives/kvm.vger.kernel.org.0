Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0CB422EA3
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhJERBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235716AbhJERBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 13:01:53 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91C8C06174E;
        Tue,  5 Oct 2021 10:00:02 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id j11-20020a4a92cb000000b002902ae8cb10so6605438ooh.7;
        Tue, 05 Oct 2021 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=DcyLwF4zH8J97zpkynsCYmFmCV6WVI4TTXZkDMBOtnY=;
        b=ikfc0vKFXbP7XSoq7rvoFQIdTaQyIR5vB/o3yZc9AuiSiGozChnEPrwW9AMlw5CSmE
         1KKcQKUoxp9ErPQAlRPBMw4bgiwGnI/fVRtCaxhFW+eWp2AFVUFylwsgFSIv4CKmXUoW
         VxdH2MwQpas5Y+Ebl9pYUac+t9I720vnZCXhovoAGYkYyTLK8P8PMMq/Pl0Bl8JD4zmK
         +fZRwM6keE3M21v1QD1pDRy+03kLWZDxQGVCQIkBQojTI5nx/iWwewL3abcc6Xu0bipc
         9BpmsUNtWxels676SA7QAz/Oklc6LtAPKimn8Y9XdpqvvYcAIRfh5sCAk49TMEQAIf0R
         RRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DcyLwF4zH8J97zpkynsCYmFmCV6WVI4TTXZkDMBOtnY=;
        b=ZB2NiMBOe647Fs4+3GtGuVIhCUceU8YsftEFYyKYbCbZCzcYdWy7x6nVzqMj8vDk50
         qiEHMlnXmvx7eUT0o6gWOJ1eZ0429Osr0iilxvejZGHmMoEn2N8gkG2NCV1ejCcGNyiH
         UnkUIllwclfhdVn+LJ+oaPqM6HCPs1+r5OhiSojOTrIhy6NQEfgkBWDZcuwagz3UrDuY
         2Bk7heiHWIFV+Fcm8FSUgaR+0IiZ1/mUjGan3azyG+MCpymYtbA78zvZc9Ld4ua3XjKu
         20jO7XMKgRQGqRZsOchVuY5pjcJeQ/TAasmur1400mm9uUPQMXAgnrXdvrQ48GddZbAl
         FW/Q==
X-Gm-Message-State: AOAM531JJGRZl9inR6WMU5Pd0SIXCLdRotvHY+Uep9t6QpkwiRqldf6t
        a1bgHqP2h+iAd+7n86pGNWIPAy1rxTL4KuM9aVF4ZMhOSF2Rmg==
X-Google-Smtp-Source: ABdhPJwvj4f8rwQJUYfN/kdxeSj7EoRN+5D6fGKYNpGULSiHlIotDI2s/k1pIK+TIq/QCPRfI4Os/AWBxTMjrVU4R2c=
X-Received: by 2002:a05:6820:358:: with SMTP id m24mr14428902ooe.34.1633453201846;
 Tue, 05 Oct 2021 10:00:01 -0700 (PDT)
MIME-Version: 1.0
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Tue, 5 Oct 2021 22:29:50 +0530
Message-ID: <CAHP4M8UD0HnGCrR=8YFTYSehd968w4bgi_R4F0gzOUCm1veHsQ@mail.gmail.com>
Subject: Fitment/Use of IOMMU in KVM world when using PCI-devices
To:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All.

I have been learning about a lot of inter-related things, kindly
correct me if I am wrong anywhere.
Till now, following have been broad observations :

a)
If we have IOMMU disabled on the host, things work fine in general on
a guest. But we cannot a attach a pci-device (physically attached to
host) to a guest.

b)
If we have IOMMU enabled on the host, we can attach a pci-device
(physically attached to a host) to a guest.




Going through the literature on the internet, it looks that we have
two modes supported by KVM / QEMU :

1.
Conventional shadow-mapping, which works in the most general case, for
GVA => GPA => HVA => HPA translations.

2.
EPT/NPT shadow-mapping, which works only if hardware-virtualization is
supported. As usual, the main purpose is to setup GVA => GPA => HVA =>
HPA translations.


In all the literature that mentioned the above modes, there were roles
of software-assisted MMU page-tables (at host-OS / guest-OS / kvm /
qemu).
The only mention of the IOMMU was with regard to pci-devices, to
maintain security and not letting guest-OSes create havoc on a
pci-device.





So, is the role of IOMMU to provide security/containership only?
In other words, if security was not a concern, would it still have
been possible to attach pci-devices on the guest-devices without
needing to enable the iommu?


Will be grateful to get pointers.


Thanks and Regards,
Ajay
