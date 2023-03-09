Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B8F6B2CD8
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCISZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 13:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCISZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 13:25:18 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D800F638F
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 10:25:16 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id cf14so2987073qtb.10
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 10:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1678386315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PCIYarRByQoUrBuBZ+peDsEg9BoCl4xGT1U1QymR6yQ=;
        b=fIGepsB3+3dl0A+jOXVDI5l3Okn4Z4D2jFHGH8CXebRjUpm1zcoCr3j7q7hPp3it8n
         ytXfnvVePPXqAIWbx9RPor96ZlnjcITTBF0McVJYh53yx1bHE1JJOtEdSDXQo6rb31j2
         KtJg7xQSBxwQsBdCAcKQOOBwcaZx17bVdTH6TXito33E3Fh1g7L4fprWW7pIpF4AMzH4
         tQ4oOZHDa1a5Ju848vWqqBNd2JrJ6pEWca6B6MsnLqnPmdellKAceWlZcEvrAgih2yEd
         OLL6sVgZRRCUjhH5nhDEt52/GBDtG38PW91EkpokXXbBfUC+4WKpwlFAPCm6d4/3bW4N
         +SUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678386315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCIYarRByQoUrBuBZ+peDsEg9BoCl4xGT1U1QymR6yQ=;
        b=frIXfNEFw5Ksj59vDW+QElfe1Eg58HMebvwXKz0Goo4d677sWafm6TrtkRu7pGJH3u
         vONYB1rAJnhCupmuS4hheS4cdjruhrxmtR3OHoqW8ZSDCs6h039btqEL9anUxup8Esfp
         T24+H7N/gKGMzCqyPI1YSBxQUuSrpEJ3cSCFm1mV5kc1+tSry4A7sd8UyG5PKSTk577C
         sZthFbxWMfwX66k+VpTh9yAMwWh50EYtl1CVKb4ul5bvfc1dxvlIwJ3dnZZCwy68YOsr
         Mb8ZZHacxJkncA66ohjpZoxa40D3F5ldimI1iANIENO9YScP4cJSic6K2CsT5hfJymPH
         sJ2Q==
X-Gm-Message-State: AO0yUKXMug2siJ620toz5ssQVEHINwwu0spKMkw/DP0ghBjc83eilTrq
        5641HCXj0RKAmgkAXhl1CdwVaQ==
X-Google-Smtp-Source: AK7set+HWAzUffR9jmS31HAqYiOrRWFVvC3r4b1eOQRbH1o/N8h/MJYBt/XY9a3aO27urwlmaSf+ng==
X-Received: by 2002:ac8:5755:0:b0:3bd:19b1:ccc with SMTP id 21-20020ac85755000000b003bd19b10cccmr6962668qtx.33.1678386315584;
        Thu, 09 Mar 2023 10:25:15 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id b142-20020ae9eb94000000b007423dad060bsm13963951qkg.87.2023.03.09.10.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 10:25:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1paKwz-00F8Jw-Lx;
        Thu, 09 Mar 2023 14:25:13 -0400
Date:   Thu, 9 Mar 2023 14:25:13 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dominik Behr <dbehr@chromium.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        upstream@semihalf.com, dtor@google.com, kevin.tian@intel.com,
        cohuck@redhat.com, abhsahu@nvidia.com, yishaih@nvidia.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the user-space
Message-ID: <ZAokiR4EC3gFAuJ1@ziepe.ca>
References: <20230307220553.631069-1-jaz@semihalf.com>
 <20230307164158.4b41e32f.alex.williamson@redhat.com>
 <CAH76GKNapD8uB0B2+m70ZScDaOM8TmPNAii9TGqRSsgN4013+Q@mail.gmail.com>
 <20230308104944.578d503c.alex.williamson@redhat.com>
 <CABUrSUD6hE=h3-Ho7L_J=OYeRUw_Bmg9o4fuw591iw9QyBQv9A@mail.gmail.com>
 <20230308130619.3736cf18.alex.williamson@redhat.com>
 <CABUrSUBBbXRVRo6b1EKBpgu7zk=8yZhQ__UXFGL_GpO+BA4Pkg@mail.gmail.com>
 <20230308163803.6bfc2922.alex.williamson@redhat.com>
 <CABUrSUAbJJJfGYQuXe-k+partE8UebEvK47zuGXEAtdAjg-yPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABUrSUAbJJJfGYQuXe-k+partE8UebEvK47zuGXEAtdAjg-yPA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 05:51:32PM -0800, Dominik Behr wrote:
> All other ACPI events that are available to userspace are on netlink already.
> As for translation of ACPI paths. It is sort of a requirement for VMM
> to translate the PCI path from host to guest because the PCI device
> tree in the guest is totally different already. The same follows for
> ACPI paths.
> 
> What would you propose instead of netlink?
> Sysfs entry for VFIO PCI device that accepts eventfd and signals the
> events via eventfd? Or moving it into ACPI layer entirely and adding
> eventfd sysfs interface for all ACPI devices?

I think Alex is asking why wouldn't you push it through the vfio
device FD? There is an unambiguous relationship between the QEMU vPCI
identity and the VFIO device, and we already have a good security
model for VMM access to the device FD.

Jason
