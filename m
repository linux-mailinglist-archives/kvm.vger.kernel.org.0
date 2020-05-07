Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02C71C9DD1
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 23:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgEGVrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 17:47:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgEGVrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 17:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588888069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V5idkJrYxhm5CKR6p7Gbs2X4uJl1eZjYfow+72g1gg4=;
        b=dCbiK0ZaFpzmJEW6u+f4koUUmZckRDhZDbWlqTj7l7I9xgx8QQVE6b6TDKNuYltO4GQLne
        ZiDROENf8xNP/O0Xvg1tpDxGBjxWHdHwU4fSfDbTjqUSnFW8Z9IkrxvLApYkPqUXXRr7TI
        AljsZLEvm+3bbgzyeuopuZ4u3vQ0S0o=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-Qu07c-YUNc61rMWjAh-_Ng-1; Thu, 07 May 2020 17:47:48 -0400
X-MC-Unique: Qu07c-YUNc61rMWjAh-_Ng-1
Received: by mail-qv1-f70.google.com with SMTP id z14so7279927qvv.6
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 14:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V5idkJrYxhm5CKR6p7Gbs2X4uJl1eZjYfow+72g1gg4=;
        b=dSVWPCE6u2ZaEtPBe4jJAS6dq8QmLKFuLq3cSxEDIgs1OMOsxYJB6QjojzKZD3rEwb
         zFqrVK0pjAf4S+xWqpD2PCXMWcMGPKsih8WPjrFkoM6H7N+nCvGEm6CeMsYYLstOr+oo
         t1VILfmkAEhPEEPpPY6xXXmU2s+EyioFb7gtYy3UA1O/CoKeFimWfHC3jFrT2JgSRJ+U
         Arz9pvlxbGjEGP9cgEtAofjtVPhXls7ZNOSNt9rnAaU3o2znRZ1OVcI2sb2yHr5EZMYN
         qNUnJEsSMhq97vqS6SUV5SJ/ga6A71kVpo5pSdSTatkIs7Zz5XMUSqs1f63P7gNiwngB
         PiZQ==
X-Gm-Message-State: AGi0PuZddoQZuJxLb1ngzmfN0Dr1VDV+j6mguTMVH+L3+9LUnZGBJCZH
        GRDESMNM2fvH2S2HNixTxMzyelnIBncjqfMafN7ypaIyyPlNiLxW3T2aa8LHUhsVScL0lRz7pA1
        pL7httsYYs9UN
X-Received: by 2002:ac8:6f52:: with SMTP id n18mr1046853qtv.239.1588888067432;
        Thu, 07 May 2020 14:47:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypKU8dHnF+0R9W7NWKvWqdYptCothy11u6hec6e2fkEn81AVH/NON7Vco4MKd/Vk4uGjBvtn/Q==
X-Received: by 2002:ac8:6f52:: with SMTP id n18mr1046826qtv.239.1588888066982;
        Thu, 07 May 2020 14:47:46 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t67sm5214265qka.17.2020.05.07.14.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 14:47:45 -0700 (PDT)
Date:   Thu, 7 May 2020 17:47:44 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200507214744.GP228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158871569380.15589.16950418949340311053.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

On Tue, May 05, 2020 at 03:54:53PM -0600, Alex Williamson wrote:
> +/*
> + * Zap mmaps on open so that we can fault them in on access and therefore
> + * our vma_list only tracks mappings accessed since last zap.
> + */
> +static void vfio_pci_mmap_open(struct vm_area_struct *vma)
> +{
> +	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);

A pure question: is this only a safety-belt or it is required in some known
scenarios?

In all cases:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

