Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E9E1759C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 12:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfEHKGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 06:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfEHKGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 06:06:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A90E806A6;
        Wed,  8 May 2019 10:06:53 +0000 (UTC)
Received: from gondolin (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5E6061B7A;
        Wed,  8 May 2019 10:06:51 +0000 (UTC)
Date:   Wed, 8 May 2019 12:06:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
Message-ID: <20190508120648.6c40231d.cohuck@redhat.com>
In-Reply-To: <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-8-farman@linux.ibm.com>
        <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
        <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
        <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
        <7ac9fb43-8d7a-9e04-8cba-fa4c63dfc413@linux.ibm.com>
        <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
        <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 08 May 2019 10:06:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 11:22:07 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> The TEST command is used to retrieve the status of the I/O-device 
> __path__ and do not go up to the device.
> I did not find clearly that it does not start a data transfer but I 
> really do not think it does.
> May be we should ask people from hardware.
> I only found that test I/O (a specific test command) do not initiate an 
> operation.

FWIW, I'm not sure about what we should do with the test command in any
case.

Currently, I see it defined as a proper command in the rather ancient
"Common I/O Device Commands" (I don't know of any newer public
version), which states that it retrieves the status on the parallel
interface _only_ (and generates a command reject on the serial
interface). IIRC, the parallel interface has been phased out quite some
time ago.

The current PoP, in contrast, defines this as an _invalid_ command
(generating a channel program check).

So, while the test command originally was designed to never initiate a
data transfer, we now have an invalid command in its place, and we
don't know if something else might change in the future (for transfer
mode, a test-like command is already defined in the PoP).

So, the safest course would probably be to handle the ->cda portion and
send the command down. We'll get a check condition on current hardware,
but it should be safe if something changes in the future.

Of course, asking some hardware folks is not a bad idea, either :)
