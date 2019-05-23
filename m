Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96392760D
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 08:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfEWGgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 02:36:45 -0400
Received: from ozlabs.org ([203.11.71.1]:59401 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWGgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 02:36:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 458ft32BtBz9s6w; Thu, 23 May 2019 16:36:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558593403; bh=i2k9PFZzZY81TWnMP3MoNOhrPgt9F0xczRulArBIXkE=;
        h=Date:From:To:Cc:Subject:From;
        b=RabZLyM8v2pxuSqruwfRDYUClybUf8RX0yqio4LRDYSF81zQaUN0E2KRpMVN4RSoJ
         zaSDvHB4cODGQOqPtkhYc2EYxZHlMKt7ImhFaQEDYZwbMDy1xtd+habJo0oR9ZJPFK
         C/zaCyfVUBLuiAVBCdzQjUgB008eeG0ONSVmvo2g8y8zHTpkFTPAqNudHPCCOtjlif
         BTrhXDmLsfdIf4b89Uk5BpGp9983clLISJnbcVQbNFle1Hfdnib5T+4zWXrVLI49QQ
         XaECcnb4Kwpunv89lIjLOSfpWSVDw1NGWie/oc5X3rn6RKjGvgK86PDc2F77xzSYCf
         ESNXxECFMT5cA==
Date:   Thu, 23 May 2019 16:34:24 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
Message-ID: <20190523063424.GB19655@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent reports of lockdep splats in the HV KVM code revealed that it
was taking the kvm->lock mutex in several contexts where a vcpu mutex
was already held.  Lockdep has only started warning since I added code
to take the vcpu mutexes in the XIVE device release functions, but
since Documentation/virtual/kvm/locking.txt specifies that the vcpu
mutexes nest inside kvm->lock, it seems that the new code is correct
and it is most of the old uses of kvm->lock that are wrong.

This series should fix the problems, by adding new mutexes that nest
inside the vcpu mutexes and using them instead of kvm->lock.

Paul.
