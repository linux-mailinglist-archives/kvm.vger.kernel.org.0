Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88185134656
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 16:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgAHPgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 10:36:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727782AbgAHPgH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 10:36:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578497766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6YNW0p309KoXFtpAU4UbagX3xQXhnEerfAmOwO0Imlk=;
        b=YAiEO1C1cfXAjw65idbOhvA+fjpjQkVFPcOgxquKwSoimh91/shLLfEILXa9w5yaCok7j/
        jyPeuWbFkhBym9m12o7AAYcRmx5jTkHbEvpmpDgzq5jeG/Ch/28OVxnZ5dbg0YAma+Uvnw
        0+C7bUlYKA4kN7bDhuqbj8DqfOpLY/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-GrEnqTf5Mzyw4bp6w9TOqg-1; Wed, 08 Jan 2020 10:36:04 -0500
X-MC-Unique: GrEnqTf5Mzyw4bp6w9TOqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94CB010054E3;
        Wed,  8 Jan 2020 15:36:03 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8CC61001938;
        Wed,  8 Jan 2020 15:36:02 +0000 (UTC)
Date:   Wed, 8 Jan 2020 16:36:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3] KVM: s390: Add new reset vcpu API
Message-ID: <20200108163600.54981741.cohuck@redhat.com>
In-Reply-To: <d3370e31-ca33-567d-ce0e-1168f603a686@redhat.com>
References: <20191205120956.50930-1-frankja@linux.ibm.com>
        <dd724da0-9bba-079e-6b6f-756762dbc942@de.ibm.com>
        <d0db08ef-ade9-93d4-105f-ace6fef50c81@linux.ibm.com>
        <3ddb7aa6-96d4-246f-a8ba-fdf2408a4ff0@de.ibm.com>
        <d3370e31-ca33-567d-ce0e-1168f603a686@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 15:44:57 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 08/01/2020 15.38, Christian Borntraeger wrote:
> > 
> > 
> > On 08.01.20 15:35, Janosch Frank wrote:  
> >> On 1/8/20 3:28 PM, Christian Borntraeger wrote:  
> >>>
> >>>
> >>> On 05.12.19 13:09, Janosch Frank wrote:
> >>> [...]  
> >>>> +4.123 KVM_S390_CLEAR_RESET
> >>>> +
> >>>> +Capability: KVM_CAP_S390_VCPU_RESETS
> >>>> +Architectures: s390
> >>>> +Type: vcpu ioctl
> >>>> +Parameters: none
> >>>> +Returns: 0
> >>>> +
> >>>> +This ioctl resets VCPU registers and control structures that QEMU
> >>>> +can't access via the kvm_run structure. The clear reset is a superset
> >>>> +of the initial reset and additionally clears general, access, floating
> >>>> +and vector registers.  
> >>>
> >>> As Thomas outlined, make it more obvious that userspace does the remaining
> >>> parts. I do not think that we want the kernel to do the things (unless it
> >>> helps you in some way for the ultravisor guests)  
> >>
> >> Ok, will do  
> > 
> > I changed my mind (see my other mail) but I would like Thomas, Conny or David
> > to ack/nack.  
> 
> I don't mind too much as long as it is properly documented, but I also
> slightly prefer to be consistent here, i.e. let the kernel clear the
> rest here, too, just like we do it already with the initial reset.

I definitely agree with the 'properly documented' part :) It's probably
enough to just state that the kernel resets the stuff, no need to go
into details (and we also don't need to update this for later versions.)

Q: Are we sure that we will always be able to reset everything from the
kernel?

