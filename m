Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DD6C3513
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCUPHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjCUPHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DC63B660
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679411186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DeboSID+flODqx9I+nMKyoD3QHmIkeCvkLB5G/ItUBU=;
        b=Xd0hCw0U5R8nooesi2sC1J62g7JCVT/LRJ1PgGwBkm9agiev+it5CbMcQpGmR2q2op1QNE
        CclrHms/X759dU+CUT1RsSTRRVo4O20ltnicKPWa3P/E5ea9b/h04Nr0phQ/0OQ70puhO2
        9BJnTi/DOpNXxp89Ns5nXasxegF1jDs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-g8Tm9A9NM0qZI2jXbyZBtQ-1; Tue, 21 Mar 2023 11:06:25 -0400
X-MC-Unique: g8Tm9A9NM0qZI2jXbyZBtQ-1
Received: by mail-wm1-f69.google.com with SMTP id m27-20020a05600c3b1b00b003ee502f1b16so15368wms.9
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679411183;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DeboSID+flODqx9I+nMKyoD3QHmIkeCvkLB5G/ItUBU=;
        b=ZQSjeqivwWF7Gnd88oDL9/+vnk+FyrH9ROMPQmvUXlOr9PJSEE6Rx3rO8JQ8iKhnPU
         4QI/YGozoQ+k/4mlXNBZEo283tiL6PBi7kU9/FdYTKS5UucoqPCMyiQcRjmOGK097avc
         zPlTuFt2S8GW1FCX7bZkujlwKgCIFYkbwSyhUOyn1HUG+7F7mR5w+c1cF4/MhkX0ZpyZ
         HGhMslMhxXVcMaH6csPIbBXV3uF7v+sfHCbEPRo4sq+firMM3vVIvrek5T7cW05OtxFK
         QGNKD6YWJ63p0dxWuzytQvbAWiE5c5ulrKMM+qiaH0a8S0m9xqhOk7FACxfRoP0UzY7C
         slwQ==
X-Gm-Message-State: AO0yUKXVH3QbDPrwwql524WdvJk8OsB/Fi0hB537xyEXMNRt24PyTdNu
        N9aG9ADd2nxF2Qx4xVtnsaoLeOhc7w+628ihlX+YUwh6YeOt+T5FHWYEgHcTnz/SQeZf7a4/8ZU
        yaJ2cPxBWuS0n
X-Received: by 2002:a7b:cd08:0:b0:3e1:f8af:8772 with SMTP id f8-20020a7bcd08000000b003e1f8af8772mr2718084wmj.9.1679411183621;
        Tue, 21 Mar 2023 08:06:23 -0700 (PDT)
X-Google-Smtp-Source: AK7set8hETz/BgtfXVgzBVy6TDRDQShGyhMxRyf2swuVorF+Gi27ydHl0d6lLBUA6v0wHiItH64mag==
X-Received: by 2002:a7b:cd08:0:b0:3e1:f8af:8772 with SMTP id f8-20020a7bcd08000000b003e1f8af8772mr2718060wmj.9.1679411183335;
        Tue, 21 Mar 2023 08:06:23 -0700 (PDT)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id e5-20020a05600c254500b003eb596cbc54sm14078799wma.0.2023.03.21.08.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:06:22 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:06:19 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBnH600JIw1saZZ7@work-vm>
References: <ZBl4592947wC7WKI@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBl4592947wC7WKI@suse.de>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Jörg Rödel (jroedel@suse.de) wrote:
> Hi,
> 
> We are happy to announce that last week our secure VM service module
> (SVSM) went public on GitHub for everyone to try it out and participate
> in its further development. It is dual-licensed under the MIT and
> APACHE-2.0 licenses.
> 
> The project is written in Rust and can be cloned from:
> 
> 	https://github.com/coconut-svsm/svsm
> 
> There are also repositories in the github project with the Linux host and
> guest, EDK2 and QEMU changes needed to run the SVSM and boot up a full
> Linux guest.
> 
> The SVSM repository contains an installation guide in the INSTALL.md
> file and contributor hints in CONTRIBUTING.md.
> 
> A blog entry with more details is here:
> 
> 	https://www.suse.com/c/suse-open-sources-secure-vm-service-module-for-confidential-computing/
> 
> We also thank AMD for implementing and providing the necessary changes
> to Linux and EDK2 to make an SVSM possible.

Interesting; it would have been nice to have known about this a little
earlier, some people have been working on stuff built on top of the AMD
one for a while.

You mention two things that I wonder how they interact:

  a) TPMs in the future at a higher ring
  b) Making (almost) unmodified guests

What interface do you expect the guest to see from the TPM - would it
look like an existing TPM hardware interface or would you need some
changes?

Dave

> Have a lot of fun!
> 
> -- 
> Jörg Rödel
> jroedel@suse.de
> 
> SUSE Software Solutions Germany GmbH
> Frankenstraße 146
> 90461 Nürnberg
> Germany
> 
> (HRB 36809, AG Nürnberg)
> Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

