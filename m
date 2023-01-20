Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AD675913
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjATPua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjATPu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:50:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9C5977B
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 07:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674229778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aavit6jM1lC6qQPOxTCnu44ZFH15mB1QS8MkjGvi8Yk=;
        b=FzioGuLfDcqO84fcjy1n7N2RheG21iX4NV3oHFLpPp5IiDMEInlYJNZqnxp7rGe+JQ7UsG
        WUyBkWrhzKkcjgYpZ/W6133zw8dQstnne5jndqh155yUuXynB5akamZeiPL4YKsWVBOYW3
        3qNvoswjvaLstV3JuaJ+a3IO4V38NMU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-lK-123AYNdaf7W3pvWcMEQ-1; Fri, 20 Jan 2023 10:49:37 -0500
X-MC-Unique: lK-123AYNdaf7W3pvWcMEQ-1
Received: by mail-io1-f72.google.com with SMTP id k1-20020a6b3c01000000b006f744aee560so3070627iob.2
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 07:49:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aavit6jM1lC6qQPOxTCnu44ZFH15mB1QS8MkjGvi8Yk=;
        b=VcFPqw8MM/5r9z6yzge1TYNq28xLm4Sl5aJPIgbsP6fcvcPWR3EeoZ5b69NJoG6+ci
         9RMkcAH4CNGWTheqsWkuWs2jyyapOAU/AdD0B+mCZskH2QXRDWdmQ4x2DecgAGdypcV5
         92uJIVSvjC9b116RJ/lm8e7Qjq6e/DxrnOD5lhEdwNiLCEVeZ8BBdmTGrJsLBr4evtmr
         dKbUziyk5Qd6YdetCI1hxZQ8SxHx7FCQmYiQgfdIjYMSFJmYxSCmCkMUL9jzikeAwHBu
         aIyklJlBXi6mFWld2Xbkp3yjgPkDK/pX7CSAKlQYyXlzTj5Ku3167K5yJ2uQGzTOL3Bh
         CXgg==
X-Gm-Message-State: AFqh2kq2J32zKMVV1g4HHL4bPsJZQCRlS1EfpJXOQtoODNf/mU5DbXRI
        8xWycpRF0+90R6e/Ndqw0HJ8EUxywlOqiSHZ9oKKYHyCPI/jOLmxvl4bVpd6BIPAQpWVjA6z2tE
        MwkNxGACCl4N9
X-Received: by 2002:a05:6e02:cc6:b0:30f:3dfe:c670 with SMTP id c6-20020a056e020cc600b0030f3dfec670mr4626051ilj.25.1674229776952;
        Fri, 20 Jan 2023 07:49:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsF7uAHGgInj7PstAuuh+H1lLdGiBCat5fhmmcQKX6OvgOleEUrY91pvtEjqx5EjFLwygLnnw==
X-Received: by 2002:a05:6e02:cc6:b0:30f:3dfe:c670 with SMTP id c6-20020a056e020cc600b0030f3dfec670mr4626033ilj.25.1674229776663;
        Fri, 20 Jan 2023 07:49:36 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z18-20020a92d192000000b0030c0217dde6sm851618ilz.0.2023.01.20.07.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 07:49:36 -0800 (PST)
Date:   Fri, 20 Jan 2023 08:49:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson, , Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Message-ID: <20230120084933.40f59c89.alex.williamson@redhat.com>
In-Reply-To: <6eff63d8-d825-aecd-12b5-e8dbf55f4372@linux.ibm.com>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
        <DS0PR11MB7529B08476DF1764F1B6C007C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
        <6eff63d8-d825-aecd-12b5-e8dbf55f4372@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Jan 2023 10:45:40 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 1/20/23 10:08 AM, Liu, Yi L wrote:
> >> From: Liu, Yi L <yi.l.liu@intel.com>
> >> Sent: Friday, January 20, 2023 11:05 PM
> >>
> >> Currently it is possible that the final put of a KVM reference comes from
> >> vfio during its device close operation.  This occurs while the vfio group
> >> lock is held; however, if the vfio device is still in the kvm device list,
> >> then the following call chain could result in a deadlock:
> >>
> >> VFIO holds group->group_lock/group_rwsem  
> >>   -> kvm_put_kvm
> >>    -> kvm_destroy_vm
> >>     -> kvm_destroy_devices
> >>      -> kvm_vfio_destroy
> >>       -> kvm_vfio_file_set_kvm
> >>        -> vfio_file_set_kvm
> >>         -> try to hold group->group_lock/group_rwsem  
> >>
> >> The key function is the kvm_destroy_devices() which triggers destroy cb
> >> of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
> >> if this path doesn't call back to vfio, this dead lock would be fixed.
> >> Actually, there is a way for it. KVM provides another point to free the
> >> kvm-vfio device which is the point when the device file descriptor is
> >> closed. This can be achieved by providing the release cb instead of the
> >> destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().
> >>
> >> 	/*
> >> 	 * Destroy is responsible for freeing dev.
> >> 	 *
> >> 	 * Destroy may be called before or after destructors are called
> >> 	 * on emulated I/O regions, depending on whether a reference is
> >> 	 * held by a vcpu or other kvm component that gets destroyed
> >> 	 * after the emulated I/O.
> >> 	 */
> >> 	void (*destroy)(struct kvm_device *dev);
> >>
> >> 	/*
> >> 	 * Release is an alternative method to free the device. It is
> >> 	 * called when the device file descriptor is closed. Once
> >> 	 * release is called, the destroy method will not be called
> >> 	 * anymore as the device is removed from the device list of
> >> 	 * the VM. kvm->lock is held.
> >> 	 */
> >> 	void (*release)(struct kvm_device *dev);
> >>
> >> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> >> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> >> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> >> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >> Signed-off-by: Yi Liu <yi.l.liu@intel.com>  
> > 
> > More background can be found in Mathew's work.
> > https://lore.kernel.org/kvm/20230114000351.115444-1-mjrosato@linux.ibm.com/T/#u
> >   
> 
> Thanks Yi.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> One small nit:  There is a comment at the very end of
> kvm_vfio_release on the kfree(dev) that still references .destroy,
> this should be updated to .release

I've fixed this locally, s/destroy/release/ in that comment.  Thanks,

Alex

