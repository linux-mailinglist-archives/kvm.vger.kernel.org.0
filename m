Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED514117220
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 17:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfLIQtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 11:49:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIQtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 11:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575910187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsWyS7b8JEqHRYm7lpV/7W+au5U3elDWM+xrFzPleL8=;
        b=QoL0l14dfBx5/laxPJFF7veY/cYsyFzHLypg7Zbib07EKGU3QCzHx5Kq3RNuGkwbgjnoJm
        1onARkUSm0X6Cy2b7g1KzGgKri3+bi78LKPfn+bfykM9upHlTtO1vFko/GyDqBgjry+/vV
        erE8TyLOd7SRE5dM07DLs6mmtZU35gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-wd8SUIZ4P7mfs15wMKRBVQ-1; Mon, 09 Dec 2019 11:49:46 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29F4F800D24;
        Mon,  9 Dec 2019 16:49:45 +0000 (UTC)
Received: from gondolin (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51C4866848;
        Mon,  9 Dec 2019 16:49:41 +0000 (UTC)
Date:   Mon, 9 Dec 2019 17:49:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 6/9] s390x: css: stsch, enumeration
 test
Message-ID: <20191209174938.7df1ffa2.cohuck@redhat.com>
In-Reply-To: <1575649588-6127-7-git-send-email-pmorel@linux.ibm.com>
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
        <1575649588-6127-7-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: wd8SUIZ4P7mfs15wMKRBVQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  6 Dec 2019 17:26:25 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.
> 
> This tests the success of STSCH I/O instruction.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  s390x/Makefile      |  2 ++
>  s390x/css.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  4 files changed, 89 insertions(+)
>  create mode 100644 s390x/css.c
> 

> +static void test_enumerate(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int scn;
> +	int cc, i;
> +	int found = 0;
> +
> +	for (scn = 0; scn < 0xffff; scn++) {
> +		cc = stsch(scn|SID_ONE, &schib);
> +		if (!cc && (pmcw->flags & PMCW_DNV)) {

Not sure when dnv is actually applicable... it is used for I/O
subchannels; chsc subchannels don't have a device; message subchannels
use a different bit IIRC; not sure about EADM subchannels.

[Not very relevant as long as we run under KVM, but should be
considered if you plan to run this test under z/VM or LPAR as well.]

> +			report_info("SID %04x Type %s PIM %x", scn,
> +				     Channel_type[PMCW_CHANNEL_TYPE(pmcw)],
> +				     pmcw->pim);
> +			for (i = 0; i < 8; i++)  {
> +				if ((pmcw->pim << i) & 0x80) {
> +					report_info("CHPID[%d]: %02x", i,
> +						    pmcw->chpid[i]);
> +					break;

That 'break;' seems odd -- won't you end up printing the first chpid in
the pim only?

Maybe modify this loop to print the chpid if the path is in the pim,
and 'n/a' or so if not?

> +				}
> +			}
> +			found++;
> +		}
> +		if (cc == 3) /* cc = 3 means no more channel in CSS */

s/channel/subchannels/

> +			break;
> +		if (found && !test_device_sid)
> +			test_device_sid = scn|SID_ONE;
> +	}
> +	if (!found) {
> +		report("Tested %d devices, none found", 0, scn);
> +		return;
> +	}
> +	report("Tested %d devices, %d found", 1, scn, found);
> +}

