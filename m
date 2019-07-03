Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642F55D258
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfGBPEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:04:40 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:42983 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBPEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:04:40 -0400
Received: by mail-wr1-f49.google.com with SMTP id x17so18219392wrl.9;
        Tue, 02 Jul 2019 08:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=w6oeN0lwMMIDvt5ODAWsSxkGGt6NY5q9LUZe/Yv8zy0=;
        b=YDXsug2VS2rjuMsdC+vDNqU3DexN46o3g/AJfl7kcBpIXfg9Vo+vbMDbiMijUaIvY2
         9zRpKVEfMpBWXloTLBZzypAucT6DbcXMFrgUaUvVGJ6ZRVaDFAaMXrGl6EeA0B5rv6es
         udb2RRgKAt1Hx6gmY2SI7L6Z9lWRBLjGRwAbke6VycNVCXnUgeCrrwdaIWu24FdrqSh3
         kDBesjktzmnN91KkM/Cf/qrQg1YMjun6iwq53GT3c3JMMjt++MyEfMOuUkLJoNdmZkiz
         Lf5QFeHJzkjnJRjb9nG8/TgOEV9l61tLcmSgxyCKKpLTbBHPaeUMS56LWmxk3EuideiT
         IOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=w6oeN0lwMMIDvt5ODAWsSxkGGt6NY5q9LUZe/Yv8zy0=;
        b=lgc6mwPCsBVnvOjdRDsm7bnBgwMXsS6VDWYQqD4xub3pJgliAXhOgIUEBaEUdB/rGW
         v1zLfFYyQAPns/V3MHzVqjU6z7Pt1YXNmDw5jHIHRx4ikHz5ae/9Pb4fWxIzViXGfk15
         T1VBkUR4qOfIf9TYOwOP/qpLDgTK2GTPQ2PkX2XELNf18saZ7HYmDkEU4u8J0ICKDRNs
         kp6pK7uHyaHHfg4Letqj4kSyIFEkWPN8uePLiJ5oFrv5y4ailKiMBmveNQRaAW8u8vh5
         p7bDyCeqjyg7wFfZChEN1kfugyozwjgKe6LZnenBO9QCBKsF2DPqLZcEdXzUOndpjgfN
         gt1Q==
X-Gm-Message-State: APjAAAXLzY87qARCGyIwA4t7/sQ1iQO2dIVKUBY+IUOul2p83WtiGMat
        1uOA6rGd6VCQMNBMplbDu/OHPMf4Xvk=
X-Google-Smtp-Source: APXvYqwKtuDjbtQFYDAFF93pprS4mfM6YAOekEBNnNbHoBx6PkGEExRI1H8HI7qrfQkOr/l2uwUnKQ==
X-Received: by 2002:adf:9e89:: with SMTP id a9mr23901675wrf.78.1562079877769;
        Tue, 02 Jul 2019 08:04:37 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b203sm3494191wmd.41.2019.07.02.08.04.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:04:37 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 0/3] KVM: nVMX: fixes for host get/set MSR
Date:   Tue,  2 Jul 2019 17:04:33 +0200
Message-Id: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These are three small bugs that were found while implementing QEMU
support for user-specified VMX features.

Paolo

Paolo Bonzini (3):
  KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS
  KVM: nVMX: allow setting the VMFUNC controls MSR
  KVM: nVMX: list VMX MSRs in KVM_GET_MSR_INDEX_LIST

 arch/x86/kvm/svm.c        |  1 +
 arch/x86/kvm/vmx/nested.c | 12 +++++++++++-
 arch/x86/kvm/vmx/vmx.c    |  2 ++
 arch/x86/kvm/x86.c        | 20 ++++++++++++++++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

-- 
1.8.3.1

