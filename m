Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FF243289F
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhJRUwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 16:52:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233709AbhJRUwO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 16:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634590201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ulj4h8MQYp21p6C7TH+LEd0CYfp/aSUgLTdq7C5hcrg=;
        b=gvHbxHa+GM7dhMUPXEIScGKycr5Zrso26pUes9BS0KVIPJ+3XQ09+4hFTYHtHpERNKJNzL
        7KFeSXueQDusuj2w5o1QA7eCfNk+AvABLo8c+c13aT37CbYiz1bMDFpkpevB+td5qPMrPw
        xsoGeNN2TCXifLRSS2ofBGfQB2byQN4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-OeVFO_f7PkCymeqCeKClhg-1; Mon, 18 Oct 2021 16:49:59 -0400
X-MC-Unique: OeVFO_f7PkCymeqCeKClhg-1
Received: by mail-wm1-f71.google.com with SMTP id h22-20020a7bc936000000b0030d998aa15eso124135wml.4
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 13:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ulj4h8MQYp21p6C7TH+LEd0CYfp/aSUgLTdq7C5hcrg=;
        b=BF7Mmy7x87v/MpWpD4OnmZz2d68WdQbPTlgLDXuJiqPpAX5rDMuBMfsIvWKTFxhYNV
         AnrEcrw51rj5PQpkZW2txGXucjvwrhHTPCaAEKyHVNxbbvh2q1JIovAAUbevwdxF/yji
         3zoCHLmTUZwsAfNPJODy6mLxNIT7NSAx39y95brD3AdhAX+0WqJe9lfBOe7Qe0atueof
         883hTBkecbFj6iDmP4hz1C69yR63a77FddxXDvH0vHkfo5xCtqXHppOySuddhkBy/G0B
         jcf3/rnHW98WxElp02Q4eYcM5GUAt6nhvHXiEjct2asyOV605nR+QqXYE21TjwAkyO5S
         /AOA==
X-Gm-Message-State: AOAM53030y0sFbhEf0AVsIybfMuzOnatzRCUslNLSSc9ELyNaL9/nOLz
        X9+D+uSdqsJtFqNfb4s7rDif2s4JRqOHMro+XG1qZIRZiuP9bkjKUwfFZU4oobyqlrE60XNrb+f
        FKdqlK5FsPule
X-Received: by 2002:a1c:3b86:: with SMTP id i128mr1363725wma.132.1634590198284;
        Mon, 18 Oct 2021 13:49:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrBSNe5FMwZd+yUOErQf/ZOVTtIeiOwVIVrSlGskYzFMqX6S5jgZ+WSDgneCkfLlCPgiLKjQ==
X-Received: by 2002:a1c:3b86:: with SMTP id i128mr1363705wma.132.1634590198054;
        Mon, 18 Oct 2021 13:49:58 -0700 (PDT)
Received: from redhat.com ([2.55.24.172])
        by smtp.gmail.com with ESMTPSA id i188sm481878wmi.5.2021.10.18.13.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:49:57 -0700 (PDT)
Date:   Mon, 18 Oct 2021 16:49:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, netdev@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>
Subject: Re: TCP/IP connections sometimes stop retransmitting packets (in
 nested virtualization case)
Message-ID: <20211018164839-mutt-send-email-mst@kernel.org>
References: <1054a24529be44e11d65e61d8760f7c59dfa073b.camel@redhat.com>
 <ed357c14-a795-3116-4db9-8486e4f71751@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed357c14-a795-3116-4db9-8486e4f71751@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021 at 11:05:23AM -0700, Eric Dumazet wrote:
> 
> 
> On 10/17/21 3:50 AM, Maxim Levitsky wrote:
> > Hi!
> >  
> > This is a follow up mail to my mail about NFS client deadlock I was trying to debug last week:
> > https://lore.kernel.org/all/e10b46b04fe4427fa50901dda71fb5f5a26af33e.camel@redhat.com/T/#u
> >  
> > I strongly believe now that this is not related to NFS, but rather to some issue in networking stack and maybe
> > to somewhat non standard .config I was using for the kernels which has many advanced networking options disabled
> > (to cut on compile time).
> > This is why I choose to start a new thread about it.
> >  
> > Regarding the custom .config file, in particular I disabled CONFIG_NET_SCHED and CONFIG_TCP_CONG_ADVANCED. 
> > Both host and the fedora32 VM run the same kernel with those options disabled.
> > 
> > 
> > My setup is a VM (fedora32) which runs Win10 HyperV VM inside, nested, which in turn runs a fedora32 VM
> > (but I was able to reproduce it with ordinary HyperV disabled VM running in the same fedora 32 VM)
> >  
> > The host is running a NFS server, and the fedora32 VM runs a NFS client which is used to read/write to a qcow2 file
> > which contains the disk of the nested Win10 VM. The L3 VM which windows VM optionally
> > runs, is contained in the same qcow2 file.
> > 
> > 
> > I managed to capture (using wireshark) packets around the failure in both L0 and L1.
> > The trace shows fair number of lost packets, a bit more than I would expect from communication that is running on the same host, 
> > but they are retransmitted and don't cause any issues until the moment of failure.
> > 
> > 
> > The failure happens when one packet which is sent from host to the guest,
> > is not received by the guest (as evident by the L1 trace, and by the following SACKS from the guest which exclude this packet), 
> > and then the host (on which the NFS server runs) never attempts to re-transmit it.
> > 
> > 
> > The host keeps on sending further TCP packets with replies to previous RPC calls it received from the fedora32 VM,
> > with an increasing sequence number, as evident from both traces, and the fedora32 VM keeps on SACK'ing those received packets, 
> > patiently waiting for the retransmission.
> >  
> > After around 12 minutes (!), the host RSTs the connection.
> > 
> > It is worth mentioning that while all of this is happening, the fedora32 VM can become hung if one attempts to access the files 
> > on the NFS share because effectively all NFS communication is blocked on TCP level.
> > 
> > I attached an extract from the two traces  (in L0 and L1) around the failure up to the RST packet.
> > 
> > In this trace the second packet with TCP sequence number 1736557331 (first one was empty without data) is not received by the guest
> > and then never retransmitted by the host.
> > 
> > Also worth noting that to ease on storage I captured only 512 bytes of each packet, but wireshark
> > notes how many bytes were in the actual packet.
> >  
> > Best regards,
> > 	Maxim Levitsky
> 
> TCP has special logic not attempting a retransmit if it senses the prior
> packet has not been consumed yet.
> 
> Usually, the consume part is done from NIC drivers at TC completion time,
> when NIC signals packet has been sent to the wire.
> 
> It seems one skb is essentially leaked somewhere, and leaked (not freed)

Thanks Eric!

Maxim since the packets that leak are transmitted on the host,
the question then is what kind of device do you use on the host
to talk to the guest? tap?


-- 
MST

