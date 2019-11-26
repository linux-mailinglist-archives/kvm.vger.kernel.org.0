Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87710A11F
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfKZPVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 10:21:13 -0500
Received: from 8bytes.org ([81.169.241.247]:52956 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbfKZPVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 10:21:13 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 768AD18E; Tue, 26 Nov 2019 16:21:11 +0100 (CET)
Date:   Tue, 26 Nov 2019 16:21:09 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: THP refcounting in disallowed_hugepage_adjust()?
Message-ID: <20191126152109.GA23850@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo et al,

while looking again at the recently added IFU patches I noticed a
dicrepancy between the two _hugepage_adjust() functions which doesn't
make sense to me yet:

	* transparent_hugepage_adjust(), when changing the value of pfn,
	  does a kvm_release_pfn_clean() on the old value and a
	  kvm_get_pfn() on the new value to make sure the code holds the
	  reference to the correct pfn.

	* disallowed_hugepage_adjust() also changes the value of the pfn
	  to map, kinda reverses what transparent_hugepage_adjust() did
	  before. But that function does not care about the pfn
	  refcounting.

I was wondering what the reason for that might be, is it just not
necessary in disallowed_hugepage_adjust() or is that an oversight?


Regards,

	Joerg
	  
