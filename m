Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243037A5633
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 01:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjIRXca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 19:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjIRXc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 19:32:28 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253B79B
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 16:32:21 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-773a0f36b4bso300475485a.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 16:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695079940; x=1695684740; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLMTysNlum9+o+e8fKNP7w+Tu5sJ8VKKnB80pE3BFH0=;
        b=IjvoLD0TTCc6A6xURATDmZNc7fa8hV3+sU4fcV85fqUzdrs2v6tS2Q4z0l0lfx4MFs
         /OilwIkmChsJjccGtXrEJCgB0v69ym33m3+13IDsmSfe4Je4zyR7rJxnDo5LIQXJSuES
         jnUgruyjVnKrOd+yLQsfM/BYyRjJmEnBJ6s1rSS09p+BSQ7CVRQ9THMdzlEaVQstZfFU
         HamNE+g+FeorfOP5SFZMe92/b5wqsr8WABbZrlKrvLdS71lEOMc0CPZAym0bE1wxaWGx
         aDec422XLLCjw/HrglC13N3evXASxgnJRTA4yWLU4qvzNtlVdwijGXg4Gkj+Mzq+F0KV
         cB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695079940; x=1695684740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLMTysNlum9+o+e8fKNP7w+Tu5sJ8VKKnB80pE3BFH0=;
        b=tuQ9ZnyvLD9ZFGhfMjJ2WAMZWUJ9g4rK2aIWY+PE1RcL6T9FNow+uY6Jfj1DZDzjj3
         1i3HIGwGVP/DUsCcOZtqv4xgphzPNZYDW+YHLd58CzYomSY45c6S5ZsEahRrWm76pBle
         3+ZiLI+xnHnXyHXfvdxlJo27KHghDguDHxVYHVfxHB/CQ2moRydR+qeSE4vsIYH0SeWi
         q0idCHY66tND12/ekwZA1NxkDD+gOnkxiuGRXdWIur/EQtHhQMKQsNiDFZHwDUftEr+T
         gJEFLo9iEM/O2RnwWZ0RHwK1iP70buWR4JTfzwL286YxgtWXgIOZTxgRT8fUXUxMFJQa
         LtWw==
X-Gm-Message-State: AOJu0YyfAjf8KHctwcY4La/daGv8wOTo3M3yBqiXykglAcN/5sVucKf5
        FsYQCpzZXFBeWC7cMxM70lZ86A==
X-Google-Smtp-Source: AGHT+IHi0Q0ITncG6MvwdO9eyFMUFwfFVtfnb2S2HnVMbYlxJUgy6VpYKVg3eHv9VYd73T9cBmTR3w==
X-Received: by 2002:a0c:da88:0:b0:651:65f4:31fa with SMTP id z8-20020a0cda88000000b0065165f431famr11660526qvj.39.1695079940190;
        Mon, 18 Sep 2023 16:32:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id s16-20020a0ce310000000b00655e83dfa16sm2709466qvl.11.2023.09.18.16.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 16:32:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiNj1-0007pV-8S;
        Mon, 18 Sep 2023 20:32:19 -0300
Date:   Mon, 18 Sep 2023 20:32:19 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Nelson, Shannon" <shannon.nelson@amd.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, tglx@linutronix.de, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
Message-ID: <20230918233219.GO13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
 <acfa5d59-242b-4b31-a3ef-b4163972f26b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acfa5d59-242b-4b31-a3ef-b4163972f26b@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 10:48:54AM -0700, Nelson, Shannon wrote:

> In our case, the VF device's msix count value found in PCI config space is
> changed by device configuration management outside of the baremetal host and
> read by the QEMU instance when it starts up, and then read by the vfio PCI
> core when QEMU requests the first IRQ.  

Oh, you definitely can't do that!

PCI config space is not allowed to change outside the OS's view and we
added sriov_set_msix_vec_count() specifically as a way to provide the
necessary synchronization between all the parts.

Randomly changing, what should be immutable, parts of the config space
from under a running OS is just non-compliant PCI behavior.

> The msix vectors are freed, but the msi_domain is not, and the msi_domain
> holds the MSIx count that it read when it was created.  If the device's MSIx
> count is increased, the next QEMU session will see the new number in PCI
> config space and try to use that new larger number, but the msi_domain is
> still using the smaller hwsize and the QEMU IRQ setup fails in
> msi_insert_desc().

Correct, devices are not allowed to change these parameters
autonomously, so there is no reason to accommodate this.

> This patch adds a msi_remove_device_irq_domain() call when the irqs are
> disabled in order to force a new read on the next IRQ allocation cycle. This
> is limited to only the vfio use of the msi_domain.

Definately no.
 
> I suppose we could add this to the trailing end of callbacks in our own
> driver, but this looks more like a generic vfio/msi issue than a driver
> specific thing.

Certainly not.
 
> The other possibility is to force the user to always do a bind cycle between
> QEMU sessions using the VF.  This seems to be unnecessary overhead and was
> not necessary when using the v6.1 kernel.  To the user, this looks like a
> regression - this is how it was reported to me.

You need to use sriov_set_msix_vec_count() and only
sriov_set_msix_vec_count() to change this parameter or I expect you
will constantly experience problems.

Jason
