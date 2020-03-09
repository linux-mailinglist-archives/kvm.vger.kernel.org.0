Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F6E17E3FA
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCIPwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:52:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38255 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgCIPwY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 11:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UB/IvUr/ugaH4om1futJLL45EG+xV5yXpIjZW59btTM=;
        b=SEVkeIrD563stOtwq2BQdj/MaInoiZYe30Ejzu2lgLBs4tglMTerTIBMiAxpML+li+dKER
        Da5hgkQDxIXC5ZcIz147M18Bu3kmBPxDr9w03tx6CL2on+hf67eDuIW+S2/bIpPLNOyr8W
        22R111slN3iyHDBsiTLAgxw5TCD1qfY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-GX1KOuizPSSfuup2z0bFpQ-1; Mon, 09 Mar 2020 11:52:21 -0400
X-MC-Unique: GX1KOuizPSSfuup2z0bFpQ-1
Received: by mail-wr1-f69.google.com with SMTP id v6so2981876wrg.22
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 08:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UB/IvUr/ugaH4om1futJLL45EG+xV5yXpIjZW59btTM=;
        b=nAat5G46tZIblIUrtDZolmxrdIxlkxd19LqB++lqg2n92icB51iZG+1wUclCPYntV2
         JuW27rKdOKmeyAQs3IPnVU5LJavFMfbOeMBEse7F1NrsyfluwfuHnsAXJ2TB1esCgi0v
         ioMf+BKYkBing7ufMVYj7PJ19ck5++/iYVHLbo8VSt/yBY30aSAKhRP/DQk+d9SN6Y7/
         sY93ZUIOsKT0A5aNndFSB5tCTNVVi1kaB9bJeSxv9van7KpOo9zMNYrgyym7v4KkVOli
         qB9SxCLQzQ4irkv+T2hhZR+mSikDnD7/rHCd+fK9KEo3Prbk3dSJD3kbAjQ2LKAZnt4A
         CF7w==
X-Gm-Message-State: ANhLgQ3h3CqQD+rEpl8wcDzs8n34m6qXnJdaaqlSJGDcJQWtcrIx2AN7
        tot4CUAHi1+0nhKkK4mFmCqDyGxOHNyJKAQfLrRZ+ypNTfmls6uYtsW8Ua9gaBKHEfyX+mWi6Dz
        xbQ+WT04A9BOh
X-Received: by 2002:a05:6000:10f:: with SMTP id o15mr6853054wrx.351.1583769139971;
        Mon, 09 Mar 2020 08:52:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtw/xasyVnTCQ/tSOo6zLe/OXjzuXj8HRel7v1396vtd+EE+E43smyhMCZMQ8azfB0ke2vLQw==
X-Received: by 2002:a05:6000:10f:: with SMTP id o15mr6853031wrx.351.1583769139725;
        Mon, 09 Mar 2020 08:52:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q4sm17294521wro.56.2020.03.09.08.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:52:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 0/6] KVM: nVMX: propperly handle enlightened vmptrld failure conditions
Date:   Mon,  9 Mar 2020 16:52:10 +0100
Message-Id: <20200309155216.204752-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Miaohe Lin noticed that we incorrectly handle enlightened vmptrld failures
in nested_vmx_run(). Trying to handle errors correctly, I fixed
a few things:
- NULL pointer dereference with invalid eVMCS GPAs [PATCH1]
- moved eVMCS mapping after migration to nested_get_vmcs12_pages() from
  nested_sync_vmcs12_to_shadow() [PATCH2]
- added propper nested_vmx_handle_enlightened_vmptrld() error handling
  [PATCH3]
- added selftests for incorrect eVMCS revision id and GPA [PATCHes4-6]

PATCH1 fixes a DoS and thus marked for stable@.

Vitaly Kuznetsov (6):
  KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs
  KVM: nVMX: stop abusing need_vmcs12_to_shadow_sync for eVMCS mapping
  KVM: nVMX: properly handle errors in
    nested_vmx_handle_enlightened_vmptrld()
  KVM: selftests: define and use EVMCS_VERSION
  KVM: selftests: test enlightened vmenter with wrong eVMCS version
  KVM: selftests: enlightened VMPTRLD with an incorrect GPA

 arch/x86/kvm/vmx/evmcs.h                      |  7 ++
 arch/x86/kvm/vmx/nested.c                     | 64 +++++++++++++------
 tools/testing/selftests/kvm/include/evmcs.h   |  2 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  2 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c | 25 ++++++--
 5 files changed, 72 insertions(+), 28 deletions(-)

-- 
2.24.1

