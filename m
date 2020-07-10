Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16E121AFA5
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 08:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgGJGoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 02:44:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59658 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726201AbgGJGoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 02:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594363460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzGyARVdJCOFDOhVSOMVsmLn0aigNSts0XTYJa817V4=;
        b=hQSMVrxV4Z5J0f46mxyjP12jnKmjSne9X/nLknBIIxGl20bIyvnzLjcqf2Q8uLthnBbp1i
        yWOTjn10QfBy01Cjq8+E/y8Gt+n0RJvhWRBOoPVziFP3YttAvM2GhwSSNWKNgy1AiLTjRE
        /+LPcOiSXofrYgjvRaG+q+OHmxSpLPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-KQOJWU4-NHmNmPCiOqvlnQ-1; Fri, 10 Jul 2020 02:44:16 -0400
X-MC-Unique: KQOJWU4-NHmNmPCiOqvlnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5459B8015CB;
        Fri, 10 Jul 2020 06:44:15 +0000 (UTC)
Received: from [10.72.13.228] (ovpn-13-228.pek2.redhat.com [10.72.13.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 167F419D7D;
        Fri, 10 Jul 2020 06:44:09 +0000 (UTC)
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <CAJaqyWdwgy0fmReOgLfL4dAv-E+5k_7z3d9M+vHqt0aO2SmOFg@mail.gmail.com>
 <20200622114622-mutt-send-email-mst@kernel.org>
 <CAJaqyWfrf94Gc-DMaXO+f=xC8eD3DVCD9i+x1dOm5W2vUwOcGQ@mail.gmail.com>
 <20200622122546-mutt-send-email-mst@kernel.org>
 <CAJaqyWfbouY4kEXkc6sYsbdCAEk0UNsS5xjqEdHTD7bcTn40Ow@mail.gmail.com>
 <CAJaqyWefMHPguj8ZGCuccTn0uyKxF9ZTEi2ASLtDSjGNb1Vwsg@mail.gmail.com>
 <419cc689-adae-7ba4-fe22-577b3986688c@redhat.com>
 <CAJaqyWedEg9TBkH1MxGP1AecYHD-e-=ugJ6XUN+CWb=rQGf49g@mail.gmail.com>
 <0a83aa03-8e3c-1271-82f5-4c07931edea3@redhat.com>
 <CAJaqyWeqF-KjFnXDWXJ2M3Hw3eQeCEE2-7p1KMLmMetMTm22DQ@mail.gmail.com>
 <20200709133438-mutt-send-email-mst@kernel.org>
 <7dec8cc2-152c-83f4-aa45-8ef9c6aca56d@redhat.com>
 <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6282b6d5-4d2b-a996-c090-6bc7ae6043ce@redhat.com>
Date:   Fri, 10 Jul 2020 14:44:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWdLOH2EceTUduKYXCQUUNo1XQ1tLgjYHTBGhtdhBPHn_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/7/10 下午1:39, Eugenio Perez Martin wrote:
> It is allocated 1 thread in lcore 1 (F_THREAD=1) which belongs to the
> same NUMA as testpmd. Actually, it is the testpmd master core, so it
> should be a good idea to move it to another lcore of the same NUMA
> node.
>
> Is this enough for pktgen to allocate the memory in that numa node?
> Since the script only write parameters to /proc, I assume that it has
> no effect to run it under numactl/taskset, and pktgen will allocate
> memory based on the lcore is running. Am I right?
>
> Thanks!
>

I think you're right.

Thanks

