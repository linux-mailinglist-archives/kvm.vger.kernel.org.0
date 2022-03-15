Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5E4D9E9B
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 16:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349464AbiCOP0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 11:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240296AbiCOP0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 11:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E33BC506CB
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647357933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+vHON9sLMUnWuhzssX9l36MlFGplt76F/UZcJvgCxP4=;
        b=X+99ZRf88IOzJ9+JRO8g00LkfrCCr33rb/Islcv1EdyNPt416IQu3nYkHWUZMPG2WTyXYc
        XPb8oduOzs34jVd7Sjp2+ViSQsvkjo9XWgz4Qh6ZuooF4H6jPC7FfCnU3s/kbVcXn79nCs
        cATK0gkCLhQLSem8z6uqqi/51uUmCqA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-jzGEg5r5PVyZP-KuHYRBxQ-1; Tue, 15 Mar 2022 11:25:32 -0400
X-MC-Unique: jzGEg5r5PVyZP-KuHYRBxQ-1
Received: by mail-wm1-f70.google.com with SMTP id r133-20020a1c448b000000b00385c3f3defaso6761396wma.3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+vHON9sLMUnWuhzssX9l36MlFGplt76F/UZcJvgCxP4=;
        b=7ghTH3qHk5ISRPzELBEZYixnAxTGQ+OIPbdHNdTmxAR1FSpw6hP5i3NH7qZipXc2vq
         sxkTXAfa5seysEnFNaFAE5OO8X3gG5s79u80uJDMDNcHSqNB0BA95R2Ivmt9cPF2kG0N
         j4gww5CkgL2cNKcEEit679ADxMy/nZOooIAe2TDtUjLhFOOPtSs4RpHK4oIUhiFa+hgg
         EOQnVy/+N3ge6dO/obnJfN/Nb40Aij4aDstKNadDTe+LoUa1Hblgxj1kE8yzJqnMW6Vt
         PRZqLtkyI3ST6edAAH9SR5pvqCuseRoAyhTm8UbNeMP1kXUzSToL8NikX2GakM7XdaES
         SRmQ==
X-Gm-Message-State: AOAM533g1K0kB4bww6yIcbYQuV8ClOgvUDrxWU2TQsDywKpw67McjfOt
        WhZSI6H0pHBsuai786n7ElwzHnSHN7HEa52FKoUqBZu5pCRhFmwUYhQICOkUYXGrQw8cWbLcBqD
        D+5I/3ooBoNBW
X-Received: by 2002:adf:d1eb:0:b0:203:9349:12b5 with SMTP id g11-20020adfd1eb000000b00203934912b5mr17160916wrd.285.1647357931076;
        Tue, 15 Mar 2022 08:25:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2ee9e3ZcJNtbvd1Kl1w+g+2sYRYd7utinJ9zHtcCamj5vcsF8wTRZt4xGOXgYc/WbZJf1CQ==
X-Received: by 2002:adf:d1eb:0:b0:203:9349:12b5 with SMTP id g11-20020adfd1eb000000b00203934912b5mr17160901wrd.285.1647357930888;
        Tue, 15 Mar 2022 08:25:30 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id e6-20020a5d5006000000b0020374784350sm15897016wrt.64.2022.03.15.08.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 08:25:30 -0700 (PDT)
Date:   Tue, 15 Mar 2022 16:25:28 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        suzuki.poulose@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <20220315152528.u7zdkjlq6okahidm@gator>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 01:33:57PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> Arm is planning to upstream tests that are being developed as part of the
> Confidential Compute Architecture [1]. Some of the tests target the
> attestation part of creating and managing a confidential compute VM, which
> requires the manipulation of messages in the Concise Binary Object
> Representation (CBOR) format [2].
> 
> I would like to ask if it would be acceptable from a license perspective to
> include the QCBOR library [3] into kvm-unit-tests, which will be used for
> encoding and decoding of CBOR messages.
> 
> The library is licensed under the 3-Clause BSD license, which is compatible
> with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> the library was open-sourced have a slightly modified 3-Clause BSD license,
> where a NON-INFRINGMENT clause is added to the disclaimer:
> 
> "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> ARE DISCLAIMED" (emphasis by me on the added clause).
> 
> The files in question include the core files that implement the
> encode/decode functionality, and thus would have to be included in
> kvm-unit-tests. I believe that the above modification does not affect the
> compatibility with GPLv2.
> 
> I would also like to mention that the QCBOR library is also used in Trusted
> Firmware-M [5], which is licensed under BSD 3-Clause.
> 
> [1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> [2] https://datatracker.ietf.org/doc/html/rfc8949
> [3] https://github.com/laurencelundblade/QCBOR
> [4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
> [5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor
> 
> Thanks,
> Alex
>

Assuming the license is OK (I'm not educated in that stuff enough to give
an opinion), then the next question is how do we want to integrate it?
Bring it all in, like we did libfdt? Or use a git submodule?

Thanks,
drew 

