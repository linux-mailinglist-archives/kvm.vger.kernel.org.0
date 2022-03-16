Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804094DAE7F
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 11:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344523AbiCPKwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 06:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbiCPKwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 06:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C3766543D
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 03:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647427876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vu3aeh48Tug76fxpmH2PAoqqXJjQdjheEKaJPV3hhHw=;
        b=Sl9geH2I7Dd1/GZ8CkydWeia/UpE7SBqc3Z41hsHfHonVFXF1W54KxZZ0i97X9vZUQWAgy
        G89cew2Z1k0nBK1owIp7F4fzuEsn3eRDP5v4U2eNeVjLcTY2utcIW3ti2rGEN96jGbasnq
        MEILabIUt26Njw6dv3Wb0pecUm/yNc0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-M9NGR9d5O7yYgZderflXZw-1; Wed, 16 Mar 2022 06:51:13 -0400
X-MC-Unique: M9NGR9d5O7yYgZderflXZw-1
Received: by mail-wm1-f72.google.com with SMTP id 14-20020a05600c104e00b003897a167353so892897wmx.8
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 03:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vu3aeh48Tug76fxpmH2PAoqqXJjQdjheEKaJPV3hhHw=;
        b=6erEY4ay9C+ZsfHXtA7EZMhpgS79PIgsMKErIMih5ZOTM2Uvut5qFMQ+epPaoP00qE
         WmbP4wFOC0e+lUPKvmZ2D6lE73wynnAYQ5heJWLwb27vSkiRQZ71zSv1vIl60YK/Ub2O
         nxTDS5Z8zqeCtfFrTHNyUJi6ajX/xC4mJaBzCjdii7EiMX/uvyGYqSrqmD5dV9iYMqSR
         rH39eEhTjehXHi77QRQ7zb8jCdm4Eny2mm81ImtlIIm/NCcwm9ldxLPtGrzMpOccqo0x
         qG7jRjhcpYcUWxpKNfMFSgw+IhfO0R1bMWiY2bRgCTYV+RC+ZwMLQwNCaxYgWRbvxUvW
         11SA==
X-Gm-Message-State: AOAM532OYXg0wGz9Bt8D2doi9zMluM+l7BP5EIw9Rlqh+sj9r5si6e1z
        jcaQsivTJ31A9BFWYNmWFgRAfrMPhEmLNqbA6frytRfWdeG4TQomZNaOXSCfiOaHdL9jFwLfCkp
        pqMSrjX3WZN/T
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id n65-20020a1c2744000000b00382a9b71c8amr6808711wmn.187.1647427872494;
        Wed, 16 Mar 2022 03:51:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTLdZCDbB2DZC73GQbo1HkG4OcuIYdVyG+RtfKXW12VXxbS+y0PyvboT8fLPkRQZmWzTJFjQ==
X-Received: by 2002:a1c:2744:0:b0:382:a9b7:1c8a with SMTP id n65-20020a1c2744000000b00382a9b71c8amr6808701wmn.187.1647427872276;
        Wed, 16 Mar 2022 03:51:12 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id m185-20020a1c26c2000000b003899ed333ffsm4443134wmm.47.2022.03.16.03.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 03:51:11 -0700 (PDT)
Date:   Wed, 16 Mar 2022 11:51:09 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        suzuki.poulose@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <20220316105109.oi5g532ylijzldte@gator>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
 <20220315152528.u7zdkjlq6okahidm@gator>
 <YjG/FyAaFsAxTLKd@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjG/FyAaFsAxTLKd@monolith.localdoman>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 10:42:31AM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Mar 15, 2022 at 04:25:28PM +0100, Andrew Jones wrote:
> > On Tue, Mar 15, 2022 at 01:33:57PM +0000, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > Arm is planning to upstream tests that are being developed as part of the
> > > Confidential Compute Architecture [1]. Some of the tests target the
> > > attestation part of creating and managing a confidential compute VM, which
> > > requires the manipulation of messages in the Concise Binary Object
> > > Representation (CBOR) format [2].
> > > 
> > > I would like to ask if it would be acceptable from a license perspective to
> > > include the QCBOR library [3] into kvm-unit-tests, which will be used for
> > > encoding and decoding of CBOR messages.
> > > 
> > > The library is licensed under the 3-Clause BSD license, which is compatible
> > > with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> > > the library was open-sourced have a slightly modified 3-Clause BSD license,
> > > where a NON-INFRINGMENT clause is added to the disclaimer:
> > > 
> > > "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> > > WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> > > MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> > > ARE DISCLAIMED" (emphasis by me on the added clause).
> > > 
> > > The files in question include the core files that implement the
> > > encode/decode functionality, and thus would have to be included in
> > > kvm-unit-tests. I believe that the above modification does not affect the
> > > compatibility with GPLv2.
> > > 
> > > I would also like to mention that the QCBOR library is also used in Trusted
> > > Firmware-M [5], which is licensed under BSD 3-Clause.
> > > 
> > > [1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> > > [2] https://datatracker.ietf.org/doc/html/rfc8949
> > > [3] https://github.com/laurencelundblade/QCBOR
> > > [4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
> > > [5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor
> > > 
> > > Thanks,
> > > Alex
> > >
> > 
> > Assuming the license is OK (I'm not educated in that stuff enough to give
> > an opinion), then the next question is how do we want to integrate it?
> > Bring it all in, like we did libfdt? Or use a git submodule?
> 
> This is still a work in progress and at this time I'm not sure how it will
> end up looking. Do you have a preference for one or the other?
>

I think I prefer a submodule, but I'm all ears on this. By coincidence the
same topic is now also being discussed here

https://lore.kernel.org/kvm/334cc93e-9843-daa9-5846-394c199e294f@redhat.com/T/#mb5db3e9143e4f2ca47d24a32b30e7b2f014934e8

Thanks,
drew 

