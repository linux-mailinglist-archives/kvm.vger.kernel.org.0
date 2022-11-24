Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CE4637EBD
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 19:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiKXSAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 13:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiKXSAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 13:00:48 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A70269AB6
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 10:00:47 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id n12so1330899qvr.11
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 10:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vR6T1WWc3XpWCUQ2N8sVBEgP3FzOAv7MN1ehO7+huGU=;
        b=D7LsK4acFJ49jpYVEYKFSg3MHiaBtGzrWFuScsC4O+6HJ3TdKzB/j6B6WQg1Ih5cr9
         95sxRCnTnksUeoCLzn5L2O5RtUmzg8gAtYsxn7KamEhRMsHbrFs2ahJfn1skyEj9ulKL
         ZcjQE9bqJUsQWwH/jcFAu6MMMYyU5XEY9lN16Yf/sy1Zlc7CKpWqtt5o5VFWxph6kiBd
         Weh2wZaquSUfHwJAe0EgOPyExSiMltaHSaWhip9bo7v0EjODxirdbRMgM9ytYuAbAHRT
         e4CXnKSEl5NE5Gl8NdohMxUpc399b8543wMIhma1NQ7H+q/Fnj4Msi9+nJ/+/UFlKbB+
         hb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR6T1WWc3XpWCUQ2N8sVBEgP3FzOAv7MN1ehO7+huGU=;
        b=QRPQkHdKK9kKFz5nLYHXxjTYN2KoPd3LTQ8IcRExkNLE1eXvFVkWEM+1m8GzlpBFkx
         XhkvsQI4CQC3ESCQsEsGSUOdS6mbu4MR8kToRxEfx6kXyh5bo614A4ITLY3L2jJz3f9o
         aOJNwXgfulF/6Y7VRhge+WSJJQrtMMHeXD5ldHExkw7xRMTKw0mkZxmV6wSQ0sLxCjcg
         ejzhbfPHZbTzYEMzVqfObNmLIHqA3gqPD98W8cBmKc0P31XMSRt+a9JzR8kWskT4t08Q
         Vo93Zdcu2Rmbpu66EdIYrMCaW4Op5++8xaalliDEC8U0J/jgQ6zDOAIGOnh+ESnaql8d
         sceA==
X-Gm-Message-State: ANoB5pm9Ws+ySjqmaro084PlNEao+ORZsvC3dy5QPS1K9SBGWMJ9R1AL
        uSfukyjvGKudtDzVGKU70g+0jQ==
X-Google-Smtp-Source: AA0mqf4wypyeB304r429FtI4J+qSzL+Fdag5hFRpLI6tfvk5NFbqP2z9vWEmzynU76/MBi6x3l9N2g==
X-Received: by 2002:a0c:e70d:0:b0:496:6092:9f0f with SMTP id d13-20020a0ce70d000000b0049660929f0fmr13465607qvn.32.1669312846495;
        Thu, 24 Nov 2022 10:00:46 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id k23-20020ac86057000000b00399b73d06f0sm895955qtm.38.2022.11.24.10.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 10:00:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oyGWi-00CKo4-EL;
        Thu, 24 Nov 2022 14:00:44 -0400
Date:   Thu, 24 Nov 2022 14:00:44 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     alex.williamson@redhat.com, maz@kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linuxarm@huawei.com
Subject: Re: [PATCH v2] vfio/pci: Verify each MSI vector to avoid invalid MSI
 vectors
Message-ID: <Y3+xTLC0io6wvPpf@ziepe.ca>
References: <1669167756-196788-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669167756-196788-1-git-send-email-chenxiang66@hisilicon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 09:42:36AM +0800, chenxiang via wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> Currently the number of MSI vectors comes from register PCI_MSI_FLAGS
> which should be power-of-2 in qemu, in some scenaries it is not the same as
> the number that driver requires in guest, for example, a PCI driver wants
> to allocate 6 MSI vecotrs in guest, but as the limitation, it will allocate
> 8 MSI vectors. So it requires 8 MSI vectors in qemu while the driver in
> guest only wants to allocate 6 MSI vectors.
> 
> When GICv4.1 is enabled, it iterates over all possible MSIs and enable the
> forwarding while the guest has only created some of mappings in the virtual
> ITS, so some calls fail. The exception print is as following:
> vfio-pci 0000:3a:00.1: irq bypass producer (token 000000008f08224d) registration
> fails:66311

With Thomas's series to make MSI more dynamic this could spell future
problems, as future kernels might have different ordering.

It is just architecturally wrong to tie the MSI programming at the PCI
level with the current state of the guest's virtual interrupt
controller.

Physical hardware doesn't do this, virtual emulation shouldn't either.

People are taking too many liberties with trapping the PCI MSI
registers through VFIO. :(

Jason
