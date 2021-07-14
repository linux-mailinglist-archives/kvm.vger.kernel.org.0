Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44A3C8217
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 11:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbhGNJzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 05:55:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238271AbhGNJzT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 05:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626256347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=icg0gvPwRGJz9uuUXCiq7UXEwnGrtfXn8+lGykTSI4U=;
        b=ej58bkUl2qBiXz+iKOlN9KHQWrLoQBw6MlfFyhHGBtuKr7e57WVKk3l4BkoBv7CEYjlPKH
        mD1EMoii3rrfS+TCebc+rn6vLWLq6IFvY57JE+wIufNMJ0EYXw0uX9LHCh+yhQh7+A3BWX
        EP6Y5tSx9shad4Km/O9vj79MNakqHFI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-EDxdF7L1PK2mor7IbM-rbg-1; Wed, 14 Jul 2021 05:52:26 -0400
X-MC-Unique: EDxdF7L1PK2mor7IbM-rbg-1
Received: by mail-wr1-f71.google.com with SMTP id 5-20020a0560001565b029013fe432d176so1200723wrz.23
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 02:52:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=icg0gvPwRGJz9uuUXCiq7UXEwnGrtfXn8+lGykTSI4U=;
        b=n4vyTFRPmv/hNB83p6sxDvi6+wdc7hTKXJUfw8W+naRbhun8vVi1ZNZ7PP5C7ZO8u1
         S19zQUL8TvOgtx+C0bSh7VqBWzL4D4ZpSDZrQqviqbqCN4qv7LkBIHpAxLAjRiotCc3Q
         9gwXLGPf/SynQHKTIBxzklm7Y0NgkTt1WKDkoX7TxFuhF0vw0v9JFggrI6C8qNql852T
         EK/AqzvN2OkEPSj//pisJsrvS9CdUVaID0GLT/sbxgOf+SA6BrGUVd29ahbDAe0FduiU
         GYeV66vKsZra3iH6t/SiQK8lPbUgh8g156oUqiqhQIBooJrq+NE5s+v3TKOdLc6Plmzr
         21ag==
X-Gm-Message-State: AOAM533HgKPF6HwtUsDV9797IzW1mLFOYx76VzAtcErRJ7wapD9tiQlG
        5Z2sjSSm/bp3v4/t0XVPZNxdCOKSNLO9lCFQpm8gJVbY2ADZat+VQhJchDYirgnSgtvybtYHhz7
        xxgeVQkp9iQ2V
X-Received: by 2002:a5d:6804:: with SMTP id w4mr11543876wru.417.1626256344877;
        Wed, 14 Jul 2021 02:52:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGq1APKVeGWyFBIONIwgXSyQW6dds1jdrV4WQGl+a002MKBsxUMjBsprzsDXyASkBfy5FbSA==
X-Received: by 2002:a5d:6804:: with SMTP id w4mr11543858wru.417.1626256344733;
        Wed, 14 Jul 2021 02:52:24 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id a64sm1529978wme.8.2021.07.14.02.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 02:52:24 -0700 (PDT)
Date:   Wed, 14 Jul 2021 10:52:21 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Dov Murik <dovmurik@linux.ibm.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 0/6] Add AMD Secure Nested Paging (SEV-SNP) support
Message-ID: <YO6z1dJxuT5cNz6T@work-vm>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
 <80b92ee9-97d8-76f2-8859-06e61fe10f71@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80b92ee9-97d8-76f2-8859-06e61fe10f71@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> 
> 
> On 7/13/21 3:05 AM, Dov Murik wrote:>
> > Particularly confusing is the `policy` attribute which is only relevant
> > for SEV / SEV-ES, while there's a new `snp.policy` attribute for SNP...
> > Maybe the irrelevant attributes should not be added to the tree when not
> > in SNP.
> 
> The policy fields are also applicable to the SNP. The main difference are:
> 
> - in SEV/SEV-ES the policy is 32-bit compare to 64-bit value in SEV-SNP.
> However, for SEV-SNP spec uses lower 32-bit value and higher bits are marked
> reserved.
> 
> - the bit field meaning are different

Ah, I see that from the SNP ABI spec (section 4.3).

That's a bit subtle; in that at the moment we select SEV or SEV-ES based
on the existing guest policy flags; I think you're saying that SEV-SNP
is enabled by the user explicitly.

> Based on this, we can introduce a new filed 'snp-policy'.

Yes, people are bound to confuse them if they're not clearly separated;
although I guess whatever comes after SNP will probably share that
longer field?

Dave

> -Brijesh
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

