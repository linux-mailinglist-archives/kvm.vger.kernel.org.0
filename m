Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848C552996E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 08:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbiEQGVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 02:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiEQGVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 02:21:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4642F3EAB8;
        Mon, 16 May 2022 23:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CFELpoLm/T5bCWScTqAlgx1Rhso0AgfMtDUILvVD5Tg=; b=Ert0PJDqria2bGBH515+4RdK3V
        k+JtKPX5RybqvZ0ZJOosCf6K+4egaua0MGLR7MNJVRO4S7soYpMJdvWzd/s6wTCSGwNqZoiCTv30i
        /ONPxsQHJp8tLb9VFvfmDuqk9s5o1NBLa+16Mfmlgec+N0xyWoM0Jb4ir3xTDfHt6zlm2Ot22sRf7
        RXl1GD7L0D8ucd3+LorFuGrXa9JqDOv8TGZ0lbLLBX9FKck83HgYmCPO0fveeh6LbYt+eCxBg+UfD
        lee/RAdY/nKAnsxLM7GmKNUf9wIjaKXZkuSS9A+/uz630QxRVDdXsmY3qWnCiTaIGi0R68673bDVN
        ZeFyfamw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nqqa7-00Bn0U-T9; Tue, 17 May 2022 06:21:19 +0000
Date:   Mon, 16 May 2022 23:21:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <YoM+3z6+9yMeLMJn@infradead.org>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
 <20220516172734.GE1343366@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516172734.GE1343366@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 02:27:34PM -0300, Jason Gunthorpe wrote:
> Normally you'd want to do what is kvm_s390_pci_register_kvm() here,
> where a failure can be propogated but then you have a race condition
> with the kvm.
> 
> Blech, maybe it is time to just fix this race condition permanently,
> what do you think? (I didn't even compile it)

This is roughly were I was planning to get to, with one difference:
I don't think we need or even want the VFIO_DEVICE_NEEDS_KVM flag.
Instead just propagation ->kvm to the device whenever it is set and
let drivers that have a hard requirements on it like gvt fail if it
isn't there.  This could still allow using vfio for userspace PCI
drivers on s390 for example or in general allow expressing a soft
requirement, just without the whole notifier mess.

The other question is if we even need an extra reference per device,
can't we hold the group reference until all devices are gone
anyway?  That would remove the need to include kvm_host.h in the
vfio code.
