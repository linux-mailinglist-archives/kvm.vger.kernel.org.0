Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8CD2B242
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 12:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfE0KeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 06:34:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36483 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfE0KeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 06:34:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id u22so2063454pfm.3;
        Mon, 27 May 2019 03:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NoLVQOqkX2/xP4sl1L3zBVgnDBCRtPDlDvXK4A/wSw0=;
        b=Hz80ASuulIzUsmAXxBDgEwmE6kIrH72Q9Nyz5A4t9i4uzNu5jmimfsepbH9wTOaVtC
         wxdquwDZFExDZLfc7HvsY/8XaTto009s/Iab1uL1XtKMzcp9lfEb63zz4If1euuTPdUP
         dV/7ArdK0mabSOWspYqAvPA5k5Z639Qx3oa8oMwFvAQQTwFt4BLaRSP8WR7qxzTdgUfs
         tBZBItnBJw+eXdQ5kDVWev83iNnNevuhwWE70Kzs5KeGc9ywnVqebZffMklEFHVyxgrE
         LJu0xMlm6desZhSSfwBrbxY3y5G8eUXfb8m5k0svRV2cTrIDIQF0InumHrAsS8CkELi4
         gQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NoLVQOqkX2/xP4sl1L3zBVgnDBCRtPDlDvXK4A/wSw0=;
        b=ViqfpBt3qoQrOVJmEXjnUm3EzKEdg1XgLvv6JR0vyxGgg8+i84oJb0Ecusa+y4bEcZ
         QkfYvlG6/VwQG+SmG8iEB+oearDA9FN4hbHjwB/PhSODUD6uA07jd0kfzLlOviZFU6U4
         6qe6CaSMpjm317Gnj0WBt8z+0m3K6Btwg6H2TvlavYrb+KQ3YeoA5FtTv84j/Aa6Bg6x
         kAcMgg9FNjWGpRan38XSv3GbTdmkH1B/euyiWicl01rtJ7tHI7pjtF+QiYECpCfYCBtO
         pJH+wCcqTFtVMTM34HYVrcnyf44o33BPF8YR5yTpP5WMsFCyV1kzsUwy2kShYsw0THEI
         DBVA==
X-Gm-Message-State: APjAAAXctLT5DZNXN4yaFq97Bp++i/zft6tGGp39UyMWe4TnvHHBxHEp
        uH6WgKCMDwYr+UXTRAwJhmhP1D5t
X-Google-Smtp-Source: APXvYqyzFty0rTKubxKCt9VPZyJo1IER2jjvbwoNWqBpCbAs/i+f5dV1ZTJJMdCNYU3TNH8X03SytA==
X-Received: by 2002:a63:f44f:: with SMTP id p15mr124959274pgk.65.1558953260447;
        Mon, 27 May 2019 03:34:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y16sm19216452pfo.133.2019.05.27.03.34.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 03:34:19 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 0/3] KVM: Yield to IPI target if necessary
Date:   Mon, 27 May 2019 18:34:12 +0800
Message-Id: <1558953255-9432-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea is from Xen, when sending a call-function IPI-many to vCPUs, 
yield if any of the IPI target vCPUs was preempted. 17% performace 
increase of ebizzy benchmark can be observed in an over-subscribe 
environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function 
IPI-many since call-function is not easy to be trigged by userspace 
workload).

Wanpeng Li (3):
  KVM: X86: Implement PV sched yield in linux guest
  KVM: X86: Implement PV sched yield hypercall
  KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest

 Documentation/virtual/kvm/cpuid.txt      |  4 ++++
 Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
 arch/x86/kvm/cpuid.c                     |  3 ++-
 arch/x86/kvm/x86.c                       | 17 +++++++++++++++++
 include/uapi/linux/kvm_para.h            |  1 +
 7 files changed, 57 insertions(+), 1 deletion(-)

-- 
2.7.4

