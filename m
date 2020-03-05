Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE57117AE42
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 19:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCEShf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 13:37:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725977AbgCEShe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 13:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583433453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yAqQBw7q9t4PgjjslG8SKuDvnBf92v/kO5v+bREuIJ8=;
        b=QsKwVdNig4WhDoGRSAZ9fExtP2Rf+hAS3lG6zWo43eDdMPdkCIZ6IiLjgP3wD0e4RM5b8U
        NtrVWUbm+0IE5xr8OplUGLoHJ3kyblxRTCEVBVKGOE5cAmtVWqoylr3i6dKZdbd2FaDHky
        TUZTM5B2GVa4dmIrvMT9gXC/6gg5FG4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-kIX4yRHjMVKe7R3mFs7Egw-1; Thu, 05 Mar 2020 13:37:30 -0500
X-MC-Unique: kIX4yRHjMVKe7R3mFs7Egw-1
Received: by mail-wr1-f72.google.com with SMTP id p5so2610787wrj.17
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 10:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yAqQBw7q9t4PgjjslG8SKuDvnBf92v/kO5v+bREuIJ8=;
        b=oZfuU1k37OFTE7gKrZDhTSZly9waHFqHD6qKKEafDv6L6B9k3DERdnWhskZCG1htnK
         tetRtxSyCYctNwNSj9UEnoEDyIUOdmwdJb8BBZe/KyUPNhNkziOCYW/OLv822JuQPRkz
         SGs+07G0/VgsC06SwnIYG7M9SW3UI8iTvPXhWqG55MWXwGvbik6ANtllQ8CN3RA3L5Jk
         32v/5h1bPpoivcGT2Chgi4E8jOr8Si4BtS015nTWkZTdy26hgHLPbO4Zu1mVTCLFSmPg
         NzqIuvlkQyYAGLTBf3ALLsj+g+tYuxF3JMWns5QamF+XVHjSv/yz0GtRSk9VLY2xDDtu
         2IkA==
X-Gm-Message-State: ANhLgQ31mCKM1SOxH3R/6ZvhSSCK99OJtG6nbaVMsrdSmqC9cDkFsC6B
        NQFDxE4pac2/s1byug91qG7wZOc4cFtez3zd57Ghrx/Ee6aouKbBCx43joeQmPRxTMuy8tj0Kk+
        pBly6O2HrI0BQ
X-Received: by 2002:adf:94a3:: with SMTP id 32mr296960wrr.276.1583433449214;
        Thu, 05 Mar 2020 10:37:29 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvhHuGisFdgFqK+06OOLUW1ehdv33D3YUuQu/8RquwUxfPL95K46vixq9wQPfQFCkl0BQDXoQ==
X-Received: by 2002:adf:94a3:: with SMTP id 32mr296951wrr.276.1583433449033;
        Thu, 05 Mar 2020 10:37:29 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u17sm9369121wmj.47.2020.03.05.10.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 10:37:28 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: VMX: cleanup VMXON region allocation
Date:   Thu,  5 Mar 2020 19:37:23 +0100
Message-Id: <20200305183725.28872-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor cleanup with no functional change (intended):
- Rename 'kvm_area' to 'vmxon_region'
- Simplify setting revision_id for VMXON region when eVMCS is in use

Changes since v1:
- Patches prefix ('KVM: VMX:' now) [Sean Christopherson]
- Add Sean's R-b to PATCH1
- Do not rename alloc_vmcs_cpu() to alloc_vmx_area_cpu() and add a comment
  explaining why we call VMXON region 'VMCS' [Sean Christopherson]

Vitaly Kuznetsov (2):
  KVM: VMX: rename 'kvm_area' to 'vmxon_region'
  KVM: VMX: untangle VMXON revision_id setting when using eVMCS

 arch/x86/kvm/vmx/vmx.c | 42 +++++++++++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.h | 12 +++++++++---
 2 files changed, 28 insertions(+), 26 deletions(-)

-- 
2.24.1

