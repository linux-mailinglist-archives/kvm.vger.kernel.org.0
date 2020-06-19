Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F542012A4
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbgFSPyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:54:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392414AbgFSPyD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592582042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=to2CQWKmk1BHkNF1i45gKO63shrPi4wxU7I0QHSWvYE=;
        b=RvEH1OMeGK6hTtAe+GYSjGNeNmGml40C3KLSqlFMzWiBqVDzRE7ipjhwGpfHBsJvNDJplF
        6bJHxb2nADA34G0efupKLaYglwVyMKZGsTvunum+wNBoESuW8LBaL8bvXW9Fe6gtfR9Y5R
        qYyEqXhG3msUJpk6VYswFOugMTnu45k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-CVn1DvXPMHOb91P4X9CdmA-1; Fri, 19 Jun 2020 11:54:00 -0400
X-MC-Unique: CVn1DvXPMHOb91P4X9CdmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55711108BD09;
        Fri, 19 Jun 2020 15:53:52 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96C9E5BAD3;
        Fri, 19 Jun 2020 15:53:47 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        kvm@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 0/2] kvm: x86/cpu: Support guest MAXPHYADDR < host MAXPHYADDR
Date:   Fri, 19 Jun 2020 17:53:42 +0200
Message-Id: <20200619155344.79579-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds support for KVM_CAP_HAS_SMALLER_MAXPHYADDR to QEMU.
Some processors might not handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR in
the expected manner. Hence, we added KVM_CAP_HAS_SMALLER_MAXPHYADDR to
KVM.
In this implementation KVM is queried for KVM_CAP_HAS_SMALLER_MAXPHYADDR
when setting vCPU physical bits, and if the CPU doesn't support 
KVM_CAP_HAS_SMALLER_MAXPHYADDR the ,phys-bits is ignore and host phyiscal
bits are used. A warning message is printed to the user.

Mohammed Gamal (2):
  kvm: Add support for KVM_CAP_HAS_SMALLER_MAXPHYADDR
  x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR for hosts that
    don't support it

 linux-headers/linux/kvm.h |  1 +
 target/i386/cpu.c         | 11 +++++++++++
 target/i386/kvm.c         |  5 +++++
 target/i386/kvm_i386.h    |  1 +
 4 files changed, 18 insertions(+)

-- 
2.26.2

