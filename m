Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBE11B0902
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 14:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgDTMN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 08:13:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57140 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726813AbgDTMN2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 08:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587384806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZTwdvHZQRaysr9wpMNaiueUnZGF9N1eQdSdXAbzfLg=;
        b=HR4/uI/7K+7iVSFhSLtMizgzn7u27p3x42g4GvoTj45lLcGtcbJxcGwdS4ajmqdCQPELmG
        q8EwgmwPlFJRAEmrPRFmryeZbKNUgU8X+Xn4EOFA/rYltaznneRFQX2B20IbFim0EP1NfO
        ZxigWjsj/fZWmzzhzGgJx4+qV1LKtOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-09doefEbNh-Rj7Q_WkfuSg-1; Mon, 20 Apr 2020 08:13:22 -0400
X-MC-Unique: 09doefEbNh-Rj7Q_WkfuSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08C9F8017FD;
        Mon, 20 Apr 2020 12:13:21 +0000 (UTC)
Received: from gondolin (ovpn-112-224.ams2.redhat.com [10.36.112.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCA515C1B2;
        Mon, 20 Apr 2020 12:13:19 +0000 (UTC)
Date:   Mon, 20 Apr 2020 14:13:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jared Rossi <jrossi@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Message-ID: <20200420141317.4537498f.cohuck@redhat.com>
In-Reply-To: <20200417182939.11460-2-jrossi@linux.ibm.com>
References: <20200417182939.11460-1-jrossi@linux.ibm.com>
        <20200417182939.11460-2-jrossi@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 14:29:39 -0400
Jared Rossi <jrossi@linux.ibm.com> wrote:

> Remove the explicit prefetch check when using vfio-ccw devices.
> This check is not needed as all Linux channel programs are intended
> to use prefetch and will be executed in the same way regardless.

Hm... my understanding is that we have the reasonable expectation that
our guests will always issue channel programs that work fine with
prefetch even if the bit is not set in the orb (including CCW IPL, in
the way it is implemented in the s390-ccw QEMU bios), and therefore
this patch is just making things less complicated.

If a future guest does issue a channel program where that does not hold
true, it will run into trouble, and I'm not sure that this would be
easy to debug. Can we log this somewhere?

Also, it might make sense to add some note of our
behaviour/expectations to Documentation/s390/vfio-ccw.rst.

> 
> Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c  | 16 ++++------------
>  drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>  drivers/s390/cio/vfio_ccw_fsm.c |  6 +++---
>  3 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 3645d1720c4b..5b47ecbb4baa 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
(...)
> @@ -690,7 +682,7 @@ void cp_free(struct channel_program *cp)
>  }
>  
>  /**
> - * cp_prefetch() - translate a guest physical address channel program to
> + * cp_fetch() - translate a guest physical address channel program to

I would not rename this -- we are still doing what is called
'prefetch', even though we also do it if the guest did not instruct us
to do so.

(also below)

>   *                 a real-device runnable channel program.
>   * @cp: channel_program on which to perform the operation
>   *

