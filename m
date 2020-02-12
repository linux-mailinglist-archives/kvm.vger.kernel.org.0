Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0F915A9B2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBLNHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:07:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22615 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgBLNHn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 08:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581512862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFhflF1hBhJOha4DSYN37Djg7mP7A+q3ubsJivvLvf0=;
        b=iJw80NxSpT3zCZH3WlbhVue/D5Nd+0wx7lbQwKWnY1bAtnlT+dr1Lep9JAYv9VvbVbDImR
        d6zgftNHx0DKkEaEX3NoWQEg0oEdWtoqpr9zca+YfsoOesaRoo/AHKMkNt08PgvE5y8eKs
        wXtlHx5rpQ34xuEdZxDy4EZXOgbY8Js=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-1_op5JqGMYGTxKIvthVypQ-1; Wed, 12 Feb 2020 08:07:38 -0500
X-MC-Unique: 1_op5JqGMYGTxKIvthVypQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6475713E4;
        Wed, 12 Feb 2020 13:07:36 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A81F219C69;
        Wed, 12 Feb 2020 13:07:31 +0000 (UTC)
Date:   Wed, 12 Feb 2020 14:07:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, aarcange@redhat.com,
        akpm@linux-foundation.org, frankja@linux.vnet.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org, mimu@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [PATCH v2 RFC] KVM: s390/interrupt: do not pin adapter
 interrupt pages
Message-ID: <20200212140729.21209127.cohuck@redhat.com>
In-Reply-To: <ba5862cd-c0ff-c0f1-bf00-8220fa407d52@de.ibm.com>
References: <567B980B-BDA5-4EF3-A96E-1542D11F2BD4@redhat.com>
        <20200211092341.3965-1-borntraeger@de.ibm.com>
        <20200212133908.6c6c9072.cohuck@redhat.com>
        <ba5862cd-c0ff-c0f1-bf00-8220fa407d52@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Feb 2020 13:44:53 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 12.02.20 13:39, Cornelia Huck wrote:
> [...]
> 
> >> +	 */
> >> +	return 0;  
> > 
> > Given that this function now always returns 0, we basically get a
> > completely useless roundtrip into the kernel when userspace is trying
> > to setup the mappings.
> > 
> > Can we define a new IO_ADAPTER_MAPPING_NOT_NEEDED or so capability that
> > userspace can check?  
> 
> Nack. This is one system call per initial indicator ccw. This is so seldom
> and cheap that I do not see a point in optimizing this. 

NB that zpci also calls this. Probably a rare event there as well.

> 
> 
> > This change in behaviour probably wants a change in the documentation
> > as well.  
> 
> Yep. 

