Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0D507046
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 16:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353308AbiDSO0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 10:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351036AbiDSO0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 10:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C57D125E8E
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 07:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650378219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pgYoda6jxeg1UkBVWOZGijo6tDurwISefvcfRWo9yGA=;
        b=fSrmWn7mWb9FbRaJOh6Jt/Yi48Sxt9wJiFg36nF6zWwmvefYBeZZktbOYQ5JqlNCUM8H0Y
        azlPJ7cUUzoUyG/mxAGXwPwSfFS1ZbfRYtWRBeBbZjyFRDk8EZL/+r6arAkbR5lzNxob9w
        xqIh0cptGYKkktgB/RLAs9PKXPk2cZI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-prJ42yEsPRmlMemh2D2Ovg-1; Tue, 19 Apr 2022 10:23:38 -0400
X-MC-Unique: prJ42yEsPRmlMemh2D2Ovg-1
Received: by mail-wr1-f69.google.com with SMTP id 46-20020adf8031000000b00207ad3febaeso1960153wrk.6
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 07:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pgYoda6jxeg1UkBVWOZGijo6tDurwISefvcfRWo9yGA=;
        b=oIcONQheuqz0q1Q33rKz1jZgsLUPiQ6NjPhKCXuFmBwVjApxyU35a3ln4o+/32auVe
         4SeBYVw31Q5GiMRdfARPqevT+6zFJG7yZCWlhI6di/hLtTBY33CbAfsTkhTlxTa1GCp+
         eA1v9XWgaX19gWwD9NrSbgu7gxjdLxghkFHtdzY7UIDKzfQTRr7iKQUsVUTgaIhmJrzn
         Qh/Mol+pOGeAQ2kcfKWEtDwvskW1+cTvMcJSfI8lBzQdnhVLHXj/1oN3M6ZcE6ZGjS4B
         Av+wWONH0iolyIajT7EJ+bSeGbz1m1h5VIRJ43+ITFrYKbe8WA8UTKvRCG7Xmaxao3Jw
         1fCA==
X-Gm-Message-State: AOAM5305sDIospxsf3aBfUB4uFGUcplmmL7lCMQnejc8mRLucagbXZmV
        9NnvtR7Hahe9fuLetyLfJmZro69IucBuS2SXGmBwUD8F6q5UDQBgVlUD6zHE/Xw/oPMMTmmARs0
        rONawwUpDJdkZ
X-Received: by 2002:adf:e0ce:0:b0:1ef:706d:d6b9 with SMTP id m14-20020adfe0ce000000b001ef706dd6b9mr12023648wri.71.1650378217466;
        Tue, 19 Apr 2022 07:23:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeH06zyVEvRzR25XqZfs6P6WlcYVWa3Pnx9E8TjyeSMb+poPRbkmrWccNm+5XAKLTet+MGFA==
X-Received: by 2002:adf:e0ce:0:b0:1ef:706d:d6b9 with SMTP id m14-20020adfe0ce000000b001ef706dd6b9mr12023635wri.71.1650378217272;
        Tue, 19 Apr 2022 07:23:37 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id h10-20020a05600c414a00b0038ebb6884d8sm23660891wmm.0.2022.04.19.07.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 07:23:36 -0700 (PDT)
Date:   Tue, 19 Apr 2022 15:23:34 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cole Robinson <crobinso@redhat.com>
Cc:     Dov Murik <dovmurik@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: adding 'official' way to dump SEV VMSA
Message-ID: <Yl7F5o5egojJ09EB@work-vm>
References: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
 <462cbf77-432a-c09c-6ec9-91556dc0f887@linux.ibm.com>
 <YlfakQfkZFOpKWeU@work-vm>
 <ac2bc657-947b-e528-791b-101447e074d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2bc657-947b-e528-791b-101447e074d8@redhat.com>
User-Agent: Mutt/2.2.1 (2022-02-19)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Cole Robinson (crobinso@redhat.com) wrote:
> On 4/14/22 4:25 AM, Dr. David Alan Gilbert wrote:
> > * Dov Murik (dovmurik@linux.ibm.com) wrote:
> >> Hi Cole,
> >>
> >> On 13/04/2022 16:36, Cole Robinson wrote:
> >>> Hi all,
> >>>
> >>> SEV-ES and SEV-SNP attestation require a copy of the initial VMSA to
> >>> validate the launch measurement. For developers dipping their toe into
> >>> SEV-* work, the easiest way to get sample VMSA data for their machine is
> >>> to grab it from a running VM.
> >>>
> >>> There's two techniques I've seen for that: patch some printing into
> >>> kernel __sev_launch_update_vmsa, or use systemtap like danpb's script
> >>> here: https://gitlab.com/berrange/libvirt/-/blob/lgtm/scripts/sev-vmsa.stp
> >>>
> >>> Seems like this could be friendlier though. I'd like to work on this if
> >>> others agree.
> >>>
> >>> Some ideas I've seen mentioned in passing:
> >>>
> >>> - debugfs entry in /sys/kernel/debug/kvm/.../vcpuX/
> >>> - new KVM ioctl
> >>> - something with tracepoints
> >>> - some kind of dump in dmesg that doesn't require a patch
> >>>
> >>> Thoughts?
> >>
> >>
> >> Brijesh suggested to me to construct the VMSA without getting any info from
> >> the host (except number of vcpus), because the initial state of the vcpus
> >> is standard and known if you use QEMU and OVMF (but that's open for discussion).
> >>
> >> I took his approach (thanks Brijesh!) and now it's how we calculate expected
> >> SNP measurements in sev-snp-measure [1].  The relevant part for VMSA construction
> >> is in [2].
> >>
> >> I plan to add SEV-ES and SEV measurements calculation to this 
> >> library/program as well.
> > 
> > Everyone seems to be writing one; you, Dan etc!
> > 
> 
> Yeah, I should have mentioned Dan's demo tool here:
> https://gitlab.com/berrange/libvirt/-/blob/lgtm/tools/virt-dom-sev-vmsa-tool.py
> 
> Tyler Fanelli is looking at adding that functionality to sevctl too FWIW
> 
> > I think I agree the right way is to build it programmatically rather
> > than taking a copy from the kernel;  it's fairly simple, although the
> > scripts get increasingly hairy as you deal with more and more VMM's and
> > firmwares.
> > 
> 
> Agreed. A nice way to dump VMSA from the kernel will be useful for
> debugging, or extending these scripts to support different VMMs.
> 
> > I think I'd like to see a new ioctl to read the initial VMSA, primarily
> > as a way of debugging so you can see what VMSA you have when something
> > goes wrong.
> > 
> 
> debugfs seems simpler for the dev user (accessing a file per CPU vs code
> to call ioctl), but beyond that I don't have any insight. Is there a
> reason you think ioctl and not debugfs?

I'm not sure how easy it is to cook up a VMSA when you ask for it;
where as following the normal route for vCPU creation and then
taking a copy of the VMSA it was about to use sounds easy.
(Although I've tried neither).

Dave

> Thanks,
> Cole
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

