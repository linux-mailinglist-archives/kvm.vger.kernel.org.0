Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE61B5F3DA5
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 10:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJDIF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 04:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJDIFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 04:05:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B3A1BE9C
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 01:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664870743;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMu76vQvIVy0lO6nNZVWjFAp1YNB5+RujDkPLYpaS9Q=;
        b=X0iVCiwaj+hR/kPqHGQBWgWAI83KxkjAfdEp7QxdoXKno/VQg7IiBTLivoWuH+ww/21AeZ
        zJZauc/Afb3V/IuabX9RUtovjABjNRZGR+MTDsaprvtFOdkQupfXho5r1kj9JOSlu4MBRn
        tOSVzQj9QXzlXWsetzYiPp/fXtjBNN8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-AZlv-s8jO5uDnuupALKBBw-1; Tue, 04 Oct 2022 04:05:39 -0400
X-MC-Unique: AZlv-s8jO5uDnuupALKBBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 540FB299E751;
        Tue,  4 Oct 2022 08:05:39 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0A2A17583;
        Tue,  4 Oct 2022 08:05:37 +0000 (UTC)
Date:   Tue, 4 Oct 2022 09:05:35 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, qemu-devel@nongnu.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH v2] mips/malta: pass RNG seed to to kernel via env var
Message-ID: <YzvpT67iJMMR9n25@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <YziPyCqwl5KIE2cf@zx2c4.com>
 <20221003103627.947985-1-Jason@zx2c4.com>
 <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b529059a-7819-e49d-e4dc-7ae79ee21ec5@amsat.org>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022 at 12:36:03AM +0200, Philippe Mathieu-Daudé wrote:
> Hi Jason,
> 
> Per https://www.qemu.org/docs/master/devel/submitting-a-patch.html#when-resending-patches-add-a-version-tag:
> 
> Send each new revision as a new top-level thread, rather than burying it
> in-reply-to an earlier revision, as many reviewers are not looking inside
> deep threads for new patches.
> 
> On 3/10/22 12:36, Jason A. Donenfeld wrote:
> > As of the kernel commit linked below, Linux ingests an RNG seed
> > passed from the hypervisor. So, pass this for the Malta platform, and
> > reinitialize it on reboot too, so that it's always fresh.
> >
> > Cc: Philippe Mathieu-Daudé <f4bug@amsat.org>
> > Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Cc: Aurelien Jarno <aurelien@aurel32.net>
> > Link: https://git.kernel.org/mips/c/056a68cea01
> 
> You seem to justify this commit by the kernel commit, which justifies
> itself mentioning hypervisor use... So the egg comes first before the
> chicken.

The kernel justification is that the guest OS needs a good RNG
seed. The kernel patch is just saying that the firmware / hypervisor
side is where this seed generally expected to come from. This is
fine, and not notably different from what Jason's already got
wired up for the various other targets in QEMU.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

