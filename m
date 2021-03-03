Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D3232C5ED
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbhCDA1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357896AbhCCLhG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 06:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614771339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FNwC8prjj0gF4xQJs2MzAMH1nDBQ8/dC2fosf9X47FM=;
        b=P++PXtCzCBgin6VPsYDfH6/PP+sA1Op+AdJV51nz+lGuB9zH4vVVxR7Uu116j3CGILoDVE
        rYtNvyyznqEfig0HLzpPMv1b4Zu9JsV8STGo6hYvI6KEP7txjVvbqeD3eQs+ygrJd6kqhb
        jVsGgZs1XUdBURquy9uZnwsRNJBmB5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-ZXOfXohzM7KHGzRliUl-jg-1; Wed, 03 Mar 2021 06:35:38 -0500
X-MC-Unique: ZXOfXohzM7KHGzRliUl-jg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E57803F4A;
        Wed,  3 Mar 2021 11:35:36 +0000 (UTC)
Received: from gondolin (ovpn-113-85.ams2.redhat.com [10.36.113.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B79DB60DA1;
        Wed,  3 Mar 2021 11:35:19 +0000 (UTC)
Date:   Wed, 3 Mar 2021 12:35:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, qemu-devel@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up
 in qemu_ram_mmap()
Message-ID: <20210303123517.04729c1e.cohuck@redhat.com>
In-Reply-To: <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
References: <20210209134939.13083-1-david@redhat.com>
        <20210209134939.13083-8-david@redhat.com>
        <20210302173243.GM397383@xz-x1>
        <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Mar 2021 20:02:34 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 02.03.21 18:32, Peter Xu wrote:
> > On Tue, Feb 09, 2021 at 02:49:37PM +0100, David Hildenbrand wrote:  
> >> @@ -899,13 +899,17 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offset, void *hostbuf,
> >>    * to grow. We also have to use MAP parameters that avoid
> >>    * read-only mapping of guest pages.
> >>    */
> >> -static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared)
> >> +static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared,
> >> +                               bool noreserve)
> >>   {
> >>       static void *mem;
> >>   
> >>       if (mem) {
> >>           /* we only support one allocation, which is enough for initial ram */
> >>           return NULL;
> >> +    } else if (noreserve) {
> >> +        error_report("Skipping reservation of swap space is not supported.");
> >> +        return NULL  
> > 
> > Semicolon missing.  
> 
> Thanks for catching that!

Regardless of that (and this patch set), can we finally get rid of
legacy_s390_alloc? We already fence off running with a kernel prior to
3.15, and KVM_CAP_S390_COW depends on ESOP -- are non-ESOP kvm hosts
still relevant? This seems to be a generation 10 feature; do we
realistically expect anyone running this on e.g. a z/VM host that
doesn't provide ESOP?

