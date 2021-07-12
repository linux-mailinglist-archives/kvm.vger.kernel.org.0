Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF083C604C
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhGLQTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229877AbhGLQTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 12:19:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626106620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hv4m93hmoudOevzGUzFxzEjRFWqYizzI6pHJhlPwIo0=;
        b=EaWxgtEC9KEbrgRsXwZCeCTf87afbr0M7nqM6ylMo7bkwuSdkT2mqSnAbxHyhHfnno02QA
        hwZ407U+IYp7jbdnKc0LkK48sCAgwM82W2yuN2siSDQ2HDvqruwJqKsL8NYqkcrFXQ9lz9
        KdQb00Bxtmxhw2m5We1gktYmvNMD/SU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-jm9r6iK_NV2qFQz1tT3myQ-1; Mon, 12 Jul 2021 12:16:59 -0400
X-MC-Unique: jm9r6iK_NV2qFQz1tT3myQ-1
Received: by mail-wr1-f72.google.com with SMTP id 32-20020adf82a30000b029013b21c75294so6172029wrc.14
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 09:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hv4m93hmoudOevzGUzFxzEjRFWqYizzI6pHJhlPwIo0=;
        b=pfjmvpyRZFCrvLVFwE1as2Ee0jWcirBnHqa3EcjrMt43ArgYu7Ham9sOnRxAH/MyDF
         V7xTWNrMbJz0vqedqlCv22rbv1npb984uqRJqaZy7LcBQlUeV4iLnRMJrnWl2MkWoB8G
         wY/rk2OaDHTLBOe9cPrl+FAU8cAFugqJpP4zj421hccqGFR9oCli3wHx18b21zpO4VuI
         qHb2rJCuj+jqnr1jx/D2a3SCk2KeRXqdqyjzpxsSlohBof1N/zwu1WdOjV4vmblGVwc8
         /7mgnh+38P/CFFk1bUzMyRvC/GDKYdee54OFbhgY9mTDdaV/oFsor84DePXxh7JnuKIC
         EmEg==
X-Gm-Message-State: AOAM532RHRiMgVhLfFfzSyumBaPkuhmQXUlTwWF1DQ+t6qDV2fVRNdpL
        REcndAhHPJnf3fc9f+VVA2bydSztsxG0axLLt7SoVtN7E7OMJxYviOhkCQkCOfL41tf7FbtrmG8
        ufNsCgYDdnPQ1
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr14947706wrd.200.1626106618390;
        Mon, 12 Jul 2021 09:16:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuWXAOlvcvmFmv8M6/I60QDW7+lh/3hblT43L11NLgeijLJdr4cQXCiexPwU/a6XZY3DSKRQ==
X-Received: by 2002:adf:d1cd:: with SMTP id b13mr14947690wrd.200.1626106618278;
        Mon, 12 Jul 2021 09:16:58 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id s6sm4879504wrt.45.2021.07.12.09.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 09:16:57 -0700 (PDT)
Date:   Mon, 12 Jul 2021 17:16:56 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     armbru@redhat.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
Message-ID: <YOxq979AtHz/0IPP@work-vm>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
 <YOxS6R5NADizMui2@work-vm>
 <14ebb720-1aee-fb3f-bd49-e41139e64b14@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14ebb720-1aee-fb3f-bd49-e41139e64b14@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> 
> 
> On 7/12/21 9:34 AM, Dr. David Alan Gilbert wrote:
> > > 
> > > $ cat snp-launch.init
> > > 
> > > # SNP launch parameters
> > > [SEV-SNP]
> > > init_flags = 0
> > > policy = 0x1000
> > > id_block = "YWFhYWFhYWFhYWFhYWFhCg=="
> > 
> > Wouldn't the 'gosvw' and 'hostdata' also be in there?
> > 
> 
> I did not included all the 8 parameters in the commit messages, mainly
> because some of them are big. I just picked 3 smaller ones.

It would be good to have a full example, even if one of them was
something like:

  stuff = ".....<upto 4096 bytes>...."

so we'd just be able to get more of an idea.

Dave

> -Brijesh
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

