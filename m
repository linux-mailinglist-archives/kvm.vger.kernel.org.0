Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159C91EE556
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgFDNaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 09:30:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41895 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726415AbgFDNaK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 09:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591277409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoXxvywU5qnS92okp+XyS/xiUW8w+QqPZm3cbn1zUIA=;
        b=GFi9HbIveglpgBzv+2RFUXNoljc71LXI0LdZlmAOIo8tji0Q1+qHEIdKJqewIYRRigN9e5
        iMULziwsx7Kfngmm0tuNgT6NFhE03pYot5P3M7pEfzpAqNSS0wGkz7Jq0U+eimJETtX3df
        hucwc/FrSzmJq/G7zTz6Rc3iBESWWnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-q3sqB2MYOd6yu_xIyYVrHQ-1; Thu, 04 Jun 2020 09:30:05 -0400
X-MC-Unique: q3sqB2MYOd6yu_xIyYVrHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4124619200D4;
        Thu,  4 Jun 2020 13:30:04 +0000 (UTC)
Received: from gondolin (ovpn-112-76.ams2.redhat.com [10.36.112.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6505C7F4E1;
        Thu,  4 Jun 2020 13:29:48 +0000 (UTC)
Date:   Thu, 4 Jun 2020 15:29:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 09/12] s390x: css: msch, enable test
Message-ID: <20200604152945.4cb433bd.cohuck@redhat.com>
In-Reply-To: <65501204-f6f3-7800-e382-63ccad77ca38@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-10-git-send-email-pmorel@linux.ibm.com>
        <20200527114239.65fa9473.cohuck@redhat.com>
        <65501204-f6f3-7800-e382-63ccad77ca38@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 4 Jun 2020 14:46:05 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-05-27 11:42, Cornelia Huck wrote:
> > On Mon, 18 May 2020 18:07:28 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> A second step when testing the channel subsystem is to prepare a channel
> >> for use.
> >> This includes:
> >> - Get the current subchannel Information Block (SCHIB) using STSCH
> >> - Update it in memory to set the ENABLE bit
> >> - Tell the CSS that the SCHIB has been modified using MSCH
> >> - Get the SCHIB from the CSS again to verify that the subchannel is
> >>    enabled.
> >> - If the subchannel is not enabled retry a predefined retries count.
> >>
> >> This tests the MSCH instruction to enable a channel succesfuly.
> >> This is NOT a routine to really enable the channel, no retry is done,
> >> in case of error, a report is made.  
> > 
> > Hm... so you retry if the subchannel is not enabled after cc 0, but you
> > don't retry if the cc indicates busy/status pending? Makes sense, as we
> > don't expect the subchannel to be busy, but a more precise note in the
> > patch description would be good :)  
> 
> OK, I add something like
> "
> - If the command succeed but subchannel is not enabled retry a

s/succeed/succeeds/ :)

>    predefined retries count.
> - If the command fails, report the failure and do not retry, even
>    if cc indicates a busy/status as we do not expect this.

"indicates busy/status pending" ?

> "

