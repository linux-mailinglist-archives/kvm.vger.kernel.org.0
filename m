Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B41E3CBF
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgE0IzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:55:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51429 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728152AbgE0IzS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 04:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590569716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PYXw+YoKr1bluRLooF3WfBA+4ZF+vPqkW7Kq0yhOR8=;
        b=PKUpTp+e9cbNlsUjCUMb4iRgsWYLPPoI+DWZzqyJSQea3IMmb+7hYZLtKWzmnTUZUEA6wP
        dhKrN85LN8id0l7YgZAJHgcunvAIDCz4zGTOGKstm10SwuiiroQ9M6js2IRV3EDHEG+uSB
        fRZqPO6TneKeiIc8TqdIyBz2ElyfAbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-Qmbjyls0Ob-aPeRP18Sy8w-1; Wed, 27 May 2020 04:55:12 -0400
X-MC-Unique: Qmbjyls0Ob-aPeRP18Sy8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0A8D107ACF5;
        Wed, 27 May 2020 08:55:11 +0000 (UTC)
Received: from gondolin (ovpn-112-223.ams2.redhat.com [10.36.112.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D51E5C1B0;
        Wed, 27 May 2020 08:55:04 +0000 (UTC)
Date:   Wed, 27 May 2020 10:55:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration
 test
Message-ID: <20200527105501.53681762.cohuck@redhat.com>
In-Reply-To: <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 18:07:27 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.
> 
> This tests the success of STSCH I/O instruction, we do not test the
> reaction of the VM for an instruction with wrong parameters.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/Makefile      |  1 +
>  s390x/css.c         | 89 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 ++
>  3 files changed, 94 insertions(+)
>  create mode 100644 s390x/css.c

(...)

> +static void test_enumerate(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +	int scn;
> +	int scn_found = 0;
> +	int dev_found = 0;
> +
> +	for (scn = 0; scn < 0xffff; scn++) {
> +		cc = stsch(scn|SID_ONE, &schib);
> +		switch (cc) {
> +		case 0:		/* 0 means SCHIB stored */
> +			break;
> +		case 3:		/* 3 means no more channels */
> +			goto out;
> +		default:	/* 1 or 2 should never happened for STSCH */
> +			report(0, "Unexpected cc=%d on subchannel number 0x%x",
> +			       cc, scn);
> +			return;
> +		}
> +
> +		/* We currently only support type 0, a.k.a. I/O channels */
> +		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
> +			continue;
> +
> +		/* We ignore I/O channels without valid devices */
> +		scn_found++;
> +		if (!(pmcw->flags & PMCW_DNV))
> +			continue;
> +
> +		/* We keep track of the first device as our test device */
> +		if (!test_device_sid)
> +			test_device_sid = scn | SID_ONE;
> +
> +		dev_found++;
> +	}
> +
> +out:
> +	report(dev_found,
> +	       "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
> +	       scn, scn_found, dev_found);

Just wondering: with the current invocation, you expect to find exactly
one subchannel with a valid device, right?

> +}
> +
> +static struct {
> +	const char *name;
> +	void (*func)(void);
> +} tests[] = {
> +	{ "enumerate (stsch)", test_enumerate },
> +	{ NULL, NULL }
> +};
> +
> +int main(int argc, char *argv[])
> +{
> +	int i;
> +
> +	report_prefix_push("Channel Subsystem");
> +	for (i = 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		tests[i].func();
> +		report_prefix_pop();
> +	}
> +	report_prefix_pop();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 07013b2..a436ec0 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -83,3 +83,7 @@ extra_params = -m 1G
>  [sclp-3g]
>  file = sclp.elf
>  extra_params = -m 3G
> +
> +[css]
> +file = css.elf
> +extra_params =-device ccw-pong

Hm... you could test enumeration even with a QEMU that does not include
support for the pong device, right? Would it be worthwhile to split out
a set of css tests that use e.g. a virtio-net-ccw device, and have a
css-pong set of tests that require the pong device?

