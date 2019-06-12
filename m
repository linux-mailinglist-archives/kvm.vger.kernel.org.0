Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B106242377
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406968AbfFLLHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405826AbfFLLHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 07:07:42 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BA83730860AE;
        Wed, 12 Jun 2019 11:07:42 +0000 (UTC)
Received: from gondolin (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFAEC17C4D;
        Wed, 12 Jun 2019 11:07:40 +0000 (UTC)
Date:   Wed, 12 Jun 2019 13:07:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/9] s390/cio: Squash cp_free() and cp_unpin_free()
Message-ID: <20190612130735.192696f4.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-2-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 12 Jun 2019 11:07:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:23 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The routine cp_free() does nothing but call cp_unpin_free(), and while
> most places call cp_free() there is one caller of cp_unpin_free() used
> when the cp is guaranteed to have not been marked initialized.
> 
> This seems like a dubious way to make a distinction, so let's combine
> these routines and make cp_free() do all the work.

Prior to the introduction of ->initialized, cp_free() only was a
wrapper around cp_unpin_free(), which made even less sense... but
checking ->initialized does not really matter at all here.

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> The RFC version of this patch received r-b's from Farhan [1] and
> Pierre [2].  This patch is almost identical to that one, but I
> opted to not include those tags because of the cp->initialized
> check that now has an impact here.  I still think this patch makes
> sense, but want them (well, Farhan) to have a chance to look it
> over since it's been six or seven months.
> 
> [1] https://patchwork.kernel.org/comment/22310411/
> [2] https://patchwork.kernel.org/comment/22317927/
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 36 +++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 20 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
