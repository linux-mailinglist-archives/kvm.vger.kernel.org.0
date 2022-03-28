Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543054E97BB
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243030AbiC1NQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 09:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbiC1NQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 09:16:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69C1C1EEDA
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 06:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648473273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=id3+cYyJwDQgX1c25DGoHtnH1cIabKIAhEPaQc89vt4=;
        b=IoNUE//xc+CHiJgQjF4mAIfd1GfBWqT+K7zkURdDZrVr+S+oWY8bKjKuXBuheEzRWvv23L
        HFAU4lI75cTtP5bPHEWm6u3F3axKdMLp+lWLS1ITbvmTFXW9Js86zdseqQWonjmdLDsfvj
        QDnofnQzXaZsy+S7lodK/ejS8I00W0k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-d5bUIeCvPPiWzsy1fDS3MA-1; Mon, 28 Mar 2022 09:14:32 -0400
X-MC-Unique: d5bUIeCvPPiWzsy1fDS3MA-1
Received: by mail-wr1-f69.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so4285425wrp.10
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 06:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=id3+cYyJwDQgX1c25DGoHtnH1cIabKIAhEPaQc89vt4=;
        b=gQd0xX6IH7FJrNtvqq8S1YewJoxlu8YFJLIpMt4G6Bw+Qn1MIufjNRdEt8vk2ao1Oo
         fBp8M4SPO+zDlWML6MFoOmOvGEUx/hctAVKomBglILRB+o8tPzdah8RJwAyVAMkUcqLP
         EXm8x4ErdUzYVYMhNF3xKHzZ2NCDF3VUwN+p0li69L4/cKYGG8zlj/85ddrU2rS/5rNe
         Hzdrt8A2cmMY5+ci8UtKJS3ftOcZ+aAGE1SYraig/myFGy7WJUBxMBvfkeYAIhNkRKey
         7LvQqmGE93BxdOmThJI9ZDRASyRSAYoodZ6Kxxx8mtaA+iq0eMvrDrS/4dNbhPzTQTdj
         9s+w==
X-Gm-Message-State: AOAM531imijPXe3nGnwENRMysS3yrWDDGzhD4XU4e5GBkA/+xqcdXblr
        daSS5zFH0CG54+us2uRc5ToB6++578V4Myjwj96PFpw+QZDqzbLXPSK0hdK5tuwulRkerrmAcfa
        Di1JXAg8ogovA
X-Received: by 2002:adf:fe8d:0:b0:203:e02e:c6c7 with SMTP id l13-20020adffe8d000000b00203e02ec6c7mr23494475wrr.37.1648473269036;
        Mon, 28 Mar 2022 06:14:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz44g4YmpRhkXqWB+XHp8AhWTMEFXzLczKSdQgiD7+lwnY0BZbX3RbX3nj8Y/+dkbTHLhKIvg==
X-Received: by 2002:adf:fe8d:0:b0:203:e02e:c6c7 with SMTP id l13-20020adffe8d000000b00203e02ec6c7mr23494443wrr.37.1648473268719;
        Mon, 28 Mar 2022 06:14:28 -0700 (PDT)
Received: from [192.168.0.173] (86-44-155-110-dynamic.agg2.cty.lmk-pgs.eircom.net. [86.44.155.110])
        by smtp.gmail.com with ESMTPSA id l3-20020a1ced03000000b0038ce57d28a1sm8699773wmh.26.2022.03.28.06.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 06:14:27 -0700 (PDT)
Message-ID: <5accdd9074f20e8fef30984285a23366b7025497.camel@redhat.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
From:   Sean Mooney <smooney@redhat.com>
To:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Date:   Mon, 28 Mar 2022 14:14:26 +0100
In-Reply-To: <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
References: <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
         <20220322145741.GH11336@nvidia.com>
         <20220322092923.5bc79861.alex.williamson@redhat.com>
         <20220322161521.GJ11336@nvidia.com>
         <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
         <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
         <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
         <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
         <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
         <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
         <20220324114605.GX11336@nvidia.com>
         <CACGkMEtTVMuc-JebEbTrb3vRUVaNJ28FV_VyFRdRquVQN9VeQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-28 at 09:53 +0800, Jason Wang wrote:
> On Thu, Mar 24, 2022 at 7:46 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > On Thu, Mar 24, 2022 at 11:50:47AM +0800, Jason Wang wrote:
> > 
> > > It's simply because we don't want to break existing userspace. [1]
> > 
> > I'm still waiting to hear what exactly breaks in real systems.
> > 
> > As I explained this is not a significant change, but it could break
> > something in a few special scenarios.
> > 
> > Also the one place we do have ABI breaks is security, and ulimit is a
> > security mechanism that isn't working right. So we do clearly need to
> > understand *exactly* what real thing breaks - if anything.
> > 
> > Jason
> > 
> 
> To tell the truth, I don't know. I remember that Openstack may do some
> accounting so adding Sean for more comments. But we really can't image
> openstack is the only userspace that may use this.
sorry there is a lot of context to this discussion i have tried to read back the
thread but i may have missed part of it.

tl;dr openstack does not currently track locked/pinned memory per use or per vm because we have
no idea when libvirt will request it or how much is needed per device. when ulimits are configured
today for nova/openstack its done at teh qemu user level outside of openstack in our installer tooling.
e.g. in tripleo the ulimits woudl be set on the nova_libvirt contaienr to constrain all vms spawned
not per vm/process.

full responce below
-------------------

openstacks history with locked/pinned/unswapable memory is a bit complicated.
we currently only request locked memory explictly in 2 cases directly
https://github.com/openstack/nova/blob/50fdbc752a9ca9c31488140ef2997ed59d861a41/nova/virt/libvirt/driver.py#L5769-L5784=
when the adminstartor configure the vm flaovr to requst amd's SEV feature or configures the flavor for realtime scheduling pirorotiy.
i say explictly as libvirt invented a request for locked/pinned pages implictly for sriov VFs and a number of other cases
which we were not aware of implictly. this only became apprent when we went to add vdpa supprot to openstack and libvirt
did not make that implict request and we had to fall back to requesting realtime instances as a workaround.

nova/openstack does have the ablity to generate the libvirt xml element that configure hard and soft limtis 
https://github.com/openstack/nova/blob/50fdbc752a9ca9c31488140ef2997ed59d861a41/nova/virt/libvirt/config.py#L2559-L2590
however it is only ever used in our test code
https://github.com/openstack/nova/search?q=LibvirtConfigGuestMemoryTune

the descirption of hard limit in the libvirt docs stongly dicurages its use with a small caveat for locked memory
https://libvirt.org/formatdomain.html#memory-tuning

   hard_limit
   
       The optional hard_limit element is the maximum memory the guest can use. The units for this value are kibibytes (i.e. blocks of 1024 bytes). Users
   of QEMU and KVM are strongly advised not to set this limit as domain may get killed by the kernel if the guess is too low, and determining the memory
   needed for a process to run is an undecidable problem; that said, if you already set locked in memory backing because your workload demands it, you'll
   have to take into account the specifics of your deployment and figure out a value for hard_limit that is large enough to support the memory
   requirements of your guest, but small enough to protect your host against a malicious guest locking all memory.
   
we coudl not figure out how to automatically comptue a hard_limit in nova that would work for everyone and we felt exposign this to our
users/operators was  bit of a cop out when they likely cant caluate that properly either. As a result we cant actully account for them today when
schduilign workloads to a host. Im not sure this woudl chagne even if you exposed new user space apis unless we 
had a way to inspect each VF to know how much locked memory that VF woudl need to lock? same for vdpa devices,
mdevs ectra. cloud system dont normaly have quotas on "locked" memory used trasitivly via passthoguh devices so even if we had this info
its not imeditly apperant how we woudl consume it without altering our existing quotas. Openstack is a self service cloud plathform
where enduser can upload there own worload iamge so its basicaly impossibel for the oeprator of the cloud to know how much memroy to set teh ard limit
too without setting it overly large in most cases. from a management applciaton point of view we currently have no insigth into how
memory will be pinned in the kernel or when libvirt will invent addtional request for pinned/locked memeory or how large they are. 

instead of going down that route operators are encuraged to use ulimit to set a global limit on the amount of memory the nova/qemu user can use.
while nova/openstack support multi tenancy we do not expose that multi tenancy to hte underlying hypervior hosts. the agents are typicly
deploy as the nova user which is a member of the libvirt and qemu groups. the vms that are created for our teants are all created as under the qemu
user/group as a result. so the qemu user is gobal ulimit on realtime systems woudl need to be set "to protect your host against a malicious guest
locking all memory" but we do not do this on a per vm or per process basis.

to avoid memory starvation we generally recommend using hugepages when ever you are locking memroy as we at least track those per numa node and
have the memroy trackign in place to know that they are not oversubscibeable. i.e. they cant be swapped so the are effectivly the same as being locked
form a user space point of view. using hugepage memory as a workaround whenever we need to account for memory lockign is not ideal but most of our
user that need sriov or vdpa are telcos so they are alreayd usign hugepages and cpu pinning in most cases so it kind of works.

since we dont currently support per instance hard_limits and dont plan to intoruce them in the future wehter this is track per process(vm) or per
user(qemu) is not going to break openstack today. it may complicate any future use of the memtune element in libvirt but we do not currently have
customer/user asking use to expose this and as a cloud solution this super low level customiation is not really somethign we
want to expose in our api anyway.

regards
sean

> 
> To me, it looks more easier to not answer this question by letting
> userspace know about the change,
> 
> Thanks
> 

