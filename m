Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4202249A73
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHSKf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 06:35:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726752AbgHSKf0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 06:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597833325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PnoCx8H0Y0jXZ99fNW246pF/90n/rcQUi5ywk+AjrA8=;
        b=Vh21mvNka2O2jM9mWGpvviaBkc6VUpl4jTS7UM+7xaXXPJrJH+KmR6u5JpmtZ5mHohh4D7
        drKOnbCw7NssYE90WL827vv4sX5pLfz/+aQqACVn30SxlmNjndg4ORyHyYH9guBO+R0oig
        BBmGNe7ZXFb+no6JH5FaqZztsw23n2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-zIhIGe_TNMOOtfQZjx92gA-1; Wed, 19 Aug 2020 06:35:21 -0400
X-MC-Unique: zIhIGe_TNMOOtfQZjx92gA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9318C100670A;
        Wed, 19 Aug 2020 10:35:20 +0000 (UTC)
Received: from gondolin (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB4827BE89;
        Wed, 19 Aug 2020 10:35:15 +0000 (UTC)
Date:   Wed, 19 Aug 2020 12:34:43 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: add Protected VM support
Message-ID: <20200819123443.2287abc3.cohuck@redhat.com>
In-Reply-To: <20200818130424.20522-5-mhartmay@linux.ibm.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
        <20200818130424.20522-5-mhartmay@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Aug 2020 15:04:24 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Add support for Protected Virtual Machine (PVM) tests. For starting a
> PVM guest we must be able to generate a PVM image by using the
> `genprotimg` tool from the s390-tools collection. This requires the
> ability to pass a machine-specific host-key document, so the option
> `--host-key-document` is added to the configure script.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  configure               |  9 +++++++++
>  s390x/Makefile          | 17 +++++++++++++++--
>  s390x/selftest.parmfile |  1 +
>  s390x/unittests.cfg     |  1 +
>  scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
>  5 files changed, 61 insertions(+), 2 deletions(-)
>  create mode 100644 s390x/selftest.parmfile
>  create mode 100644 scripts/s390x/func.bash

(...)

> +function arch_cmd_s390x()
> +{
> +	local cmd=$1
> +	local testname=$2
> +	local groups=$3
> +	local smp=$4
> +	local kernel=$5
> +	local opts=$6
> +	local arch=$7
> +	local check=$8
> +	local accel=$9
> +	local timeout=${10}
> +
> +	# run the normal test case
> +	"$cmd" "${testname}" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +
> +	# run PV test case
> +	kernel=${kernel%.elf}.pv.bin
> +	if [ ! -f "${kernel}" ]; then
> +		if [ -z "${HOST_KEY_DOCUMENT}" ]; then
> +			print_result 'SKIP' $testname '(no host-key document specified)'
> +			return 2
> +		fi
> +
> +		print_result 'SKIP' $testname '(PVM image was not created)'

When can that happen? Don't we already fail earlier if we specified a
host key document, but genprotimg does not work?

> +		return 2
> +	fi
> +	"$cmd" "${testname}_PV" "$groups pv" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +}

