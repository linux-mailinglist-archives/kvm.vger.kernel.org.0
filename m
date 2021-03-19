Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0351C341BDF
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 12:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCSL5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 07:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhCSL51 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 07:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616155046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rbAZp1REyqpJd0tlP5aJS8RZbdHhglDuIucuVAOLTes=;
        b=YYNqaQAEbEiktJikocLcXrbXH50Jx6pBYDR00Gmh5RaMOeqtfFAQD/Oj5aq0YIadzSy6Ln
        CFHSMyGyhvZMOdzPruT3W4DG6f3Nv+qd+PK6kTiILzm04TvGSeVpytJGO6fhRWZSpJqnCJ
        tILxoaAodk9MA0Xigqb6ZYgZrlNQF7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-JsZI69VjO_6yvBQx2cCkww-1; Fri, 19 Mar 2021 07:57:25 -0400
X-MC-Unique: JsZI69VjO_6yvBQx2cCkww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DA6A81431F;
        Fri, 19 Mar 2021 11:57:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.242])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C432B6085A;
        Fri, 19 Mar 2021 11:57:22 +0000 (UTC)
Date:   Fri, 19 Mar 2021 12:57:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] configure: arm/arm64: Add --earlycon
 option to set UART type and address
Message-ID: <20210319115720.vjuvi6rxebhyrdo7@kamzik.brq.redhat.com>
References: <20210318162022.84482-1-alexandru.elisei@arm.com>
 <20210318164157.xervbl23zvqmqdli@kamzik.brq.redhat.com>
 <d8403f28-c47c-d8eb-4131-c13a1fdd9a73@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8403f28-c47c-d8eb-4131-c13a1fdd9a73@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 11:37:51AM +0000, Alexandru Elisei wrote:
> > You can also drop 'cut' and just do something like
> >
> > IFS=, read -r name type_addr addr <<<"$earlycon"
> 
> That looks much nicer and concise, and I prefer it to my approach.
> 
> However, I believe it requires a certain version of bash to work. On bash 5.1.4
> and 4.3.48 (copyright says it's from 2013), it works as expected. On bash 3.2.57
> (version used by MacOS), the result of the command is that the variable name
> contains the string with the comma replaced by space, and the other variables are
> empty. Using cut works with this version. According to the copyright notice, bash
> 3.2.57 is from 2007, so extremely old.
> 
> Did some googling for the query "bash split string" and according to this stack
> overflow question [1] (second reply), using IFS works for bash >= 4.2. Don't know
> how accurate it is.
> 
> I guess the question here is how compatible we want to be with regard to the bash
> version. I am not familiar with bash programming, so I will defer to your decision.

From time to time we've had this come up with kvm-unit-tests. The result
has always been to say "yeah, we should figure out our minimally required
Bash version and document that", but then we never do... It sounds like
you've identified Bash 4.2 being required for this IFS idiom. As we
already use this idiom in other places in kvm-unit-tests, then I think
the right thing to do is to test running all the current scripts with
Bash 4.2, and if that works, finally document it. I'll do that ASAP.

> > And/or should we do a quick sanity check on the address?
> > Something like
> >
> >   [[ $addr =~ ^0?x?[0-9a-f]+$ ]]
> 
> Another great suggestion. The pattern above doesn't take into account character
> case and the fact that 0xa is a valid number, but a is not. Best I could come up
> with is:
> 
> [[ $addr =~ ^0(x|X)[0-9a-fA-F]+$ ]] || [[ $addr =~ ^[0-9]+$ ]]
> 
> What do you think?

LGTM

Thanks,
drew

