Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167CF17B1C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 15:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfEHNy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 09:54:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35984 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfEHNy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 09:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fZD1MoMGqALYimoOBuM5A+SPAn0BauM3Ob0ObHySi70=; b=pfRLPHPlacy/hp+n76u0JY6mI
        4m/hLoi6Ly6wgCX9gzT/2uhT5icYsNiZlBWeITMyrvRQKQntRWXQeRKSkpe+ubcd3uyG0VpPhUHaP
        erhVHjXyRW63sPrezzVBV02W1sfIJMHmHc+vRqO/rodmHdurhZ0jUHdixYksIlEM5AcUd6RgIq4VK
        mKNRe3/rCaX87BOFT831OPunNTQXZaHoVpYjeFby0CXQSfqYQK8tURT96pv3goljdkqbUoobfpzfI
        scvnAZa72YPcwtFJcMA8y/I77+bzHQYYShKF6odr+B4W9bNP8lppWiZ00cDZ/tNxPH1WoLjP1VL+6
        e37RamlHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hON29-0000xX-Uj; Wed, 08 May 2019 13:54:57 +0000
Date:   Wed, 8 May 2019 06:54:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sebastian Ott <sebott@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
Message-ID: <20190508135457.GA3530@infradead.org>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-7-pasic@linux.ibm.com>
 <alpine.LFD.2.21.1905081522300.1773@schleppi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1905081522300.1773@schleppi>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 03:46:42PM +0200, Sebastian Ott wrote:
> > +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> > +				sizeof(*io_priv->dma_area),
> > +				&io_priv->dma_area_dma, GFP_KERNEL);
> 
> This needs GFP_DMA.
> You use a genpool for ccw_private->dma and not for iopriv->dma - looks
> kinda inconsistent.

dma_alloc_* never needs GFP_DMA.  It selects the zone to allocate
from based on the dma_coherent_mask of the device.
