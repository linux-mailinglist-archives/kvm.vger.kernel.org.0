Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C9510CD60
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfK1RAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 12:00:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29662 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726582AbfK1RAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 12:00:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574960424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fv4RwcNNp7XS514JyMlotGKN4vIPVkxnNBmEixIXjkY=;
        b=Eh0c4JRvCDF0yRMI5SiZCUZ5VvAT+YbnE0vztnOPAW9PSSL4Y+PvuoVdsAAcAJXf7y18+7
        6ScWvZBFakC1YYR1Je07+++JxRD0+fIOqc3TnkmFSGbZLGync0puQvXjg5bCZGcKpUfZjK
        48lWif7nL2tPQa4yZptafWqZi2h4bWU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-b4eZxIKQNMijn7kQdcIxjA-1; Thu, 28 Nov 2019 12:00:21 -0500
Received: by mail-qt1-f197.google.com with SMTP id b26so17279912qtr.23
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 09:00:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CjsE4re1wLvd9KvTD/unIUCFWfCv26fuPFA042fYEX8=;
        b=FBiBivO4z6SmSIzkkkkTlOhySg4e9PzlNH9fbmCz5EuOBLvBeKqKe3AaDOp08JM7Dv
         9vipGDhyqa+Xh2j20SCUKdhrGSFa67ImwSEfafq7GG5yW6kU+FO1rrj3syaoX0jYH8VV
         xxTV5NLhVfNpJkQc/SsyRPPMwAhisxptJ1/G/UvjTVc4fVV/DSFYs/zhElKDhhHw5heo
         pgwsj8BmSCZ3t/fTY4UE3zNSsjkgIwuzkRnWPiX1ljGc9u7YFIdie7f4jVPtMslccVB0
         tRXkmxBZCMic4/sVwbYvtLv9BVVvdXeheYfZ/+9oEer2Ry/gHxw8E+M50123DemCiLnF
         mQtw==
X-Gm-Message-State: APjAAAVCtoLhQKBEP26hyVzDCsjdPfc2WMF1Fst1YgBuaH7T8MLKGP6n
        cEZc+y6dmlw7aYooteC1RJWKxYer8kFY6Pu6PC/dvpoZEy0OTvCKqd7u6SpSJJBRCd6/pGN2D3e
        xtkua85WA3dUg
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr11740968qvb.224.1574960420979;
        Thu, 28 Nov 2019 09:00:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnYRK1tLWUSsZjlDcgFK8SkTJKWRgk9624Hq8VpzROgc2KHMpQ45E4b0Uiwk5La/kNeK5amg==
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr11740895qvb.224.1574960420128;
        Thu, 28 Nov 2019 09:00:20 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id f22sm10224147qtc.43.2019.11.28.09.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:00:19 -0800 (PST)
Date:   Thu, 28 Nov 2019 12:00:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
Subject: Re: [PATCH v14 6/6] virtio-balloon: Add support for providing unused
 page reports to host
Message-ID: <20191128115436-mutt-send-email-mst@kernel.org>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
 <20191119214653.24996.90695.stgit@localhost.localdomain>
 <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
MIME-Version: 1.0
In-Reply-To: <65de00cf-5969-ea2e-545b-2228a4c859b0@redhat.com>
X-MC-Unique: b4eZxIKQNMijn7kQdcIxjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 04:25:54PM +0100, David Hildenbrand wrote:
> On 19.11.19 22:46, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >=20
> > Add support for the page reporting feature provided by virtio-balloon.
> > Reporting differs from the regular balloon functionality in that is is
> > much less durable than a standard memory balloon. Instead of creating a
> > list of pages that cannot be accessed the pages are only inaccessible
> > while they are being indicated to the virtio interface. Once the
> > interface has acknowledged them they are placed back into their respect=
ive
> > free lists and are once again accessible by the guest system.
>=20
> Maybe add something like "In contrast to ordinary balloon
> inflation/deflation, the guest can reuse all reported pages immediately
> after reporting has finished, without having to notify the hypervisor
> about it (e.g., VIRTIO_BALLOON_F_MUST_TELL_HOST does not apply)."

Maybe we can make apply. The effect of reporting a page is effectively
putting it in a balloon then immediately taking it out. Maybe without
VIRTIO_BALLOON_F_MUST_TELL_HOST the pages can be reused before host
marked buffers used?

We didn't teach existing page hinting to behave like this, but maybe we
should, and maybe it's not too late, not a long time passed
since it was merged, and the whole shrinker based thing
seems to have been broken ...


BTW generally UAPI patches will have to be sent to virtio-dev
mailing list before they are merged.

> [...]
>=20
> >  /*
> >   * Balloon device works in 4K page units.  So each page is pointed to =
by
> > @@ -37,6 +38,9 @@
> >  #define VIRTIO_BALLOON_FREE_PAGE_SIZE \
> >  =09(1 << (VIRTIO_BALLOON_FREE_PAGE_ORDER + PAGE_SHIFT))
> > =20
> > +/*  limit on the number of pages that can be on the reporting vq */
> > +#define VIRTIO_BALLOON_VRING_HINTS_MAX=0916
>=20
> Maybe rename that from HINTS to REPORTS
>=20
> > +
> >  #ifdef CONFIG_BALLOON_COMPACTION
> >  static struct vfsmount *balloon_mnt;
> >  #endif
> > @@ -46,6 +50,7 @@ enum virtio_balloon_vq {
> >  =09VIRTIO_BALLOON_VQ_DEFLATE,
> >  =09VIRTIO_BALLOON_VQ_STATS,
> >  =09VIRTIO_BALLOON_VQ_FREE_PAGE,
> > +=09VIRTIO_BALLOON_VQ_REPORTING,
> >  =09VIRTIO_BALLOON_VQ_MAX
> >  };
> > =20
> > @@ -113,6 +118,10 @@ struct virtio_balloon {
> > =20
> >  =09/* To register a shrinker to shrink memory upon memory pressure */
> >  =09struct shrinker shrinker;
> > +
> > +=09/* Unused page reporting device */
>=20
> Sounds like the device is unused :D
>=20
> "Device info for reporting unused pages" ?
>=20
> I am in general wondering, should we rename "unused" to "free". I.e.,
> "free page reporting" instead of "unused page reporting"? Or what was
> the motivation behind using "unused" ?
>=20
> > +=09struct virtqueue *reporting_vq;
> > +=09struct page_reporting_dev_info pr_dev_info;
> >  };
> > =20
> >  static struct virtio_device_id id_table[] =3D {
> > @@ -152,6 +161,32 @@ static void tell_host(struct virtio_balloon *vb, s=
truct virtqueue *vq)
> > =20
> >  }
> > =20
> > +void virtballoon_unused_page_report(struct page_reporting_dev_info *pr=
_dev_info,
> > +=09=09=09=09    unsigned int nents)
> > +{
> > +=09struct virtio_balloon *vb =3D
> > +=09=09container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> > +=09struct virtqueue *vq =3D vb->reporting_vq;
> > +=09unsigned int unused, err;
> > +
> > +=09/* We should always be able to add these buffers to an empty queue.=
 */
>=20
> This comment somewhat contradicts the error handling (and comment)
> below. Maybe just drop it?
>=20
> > +=09err =3D virtqueue_add_inbuf(vq, pr_dev_info->sg, nents, vb,
> > +=09=09=09=09  GFP_NOWAIT | __GFP_NOWARN);
> > +
> > +=09/*
> > +=09 * In the extremely unlikely case that something has changed and we
> > +=09 * are able to trigger an error we will simply display a warning
> > +=09 * and exit without actually processing the pages.
> > +=09 */
> > +=09if (WARN_ON(err))
> > +=09=09return;
>=20
> Maybe WARN_ON_ONCE? (to not flood the log on recurring errors)
>=20
> > +
> > +=09virtqueue_kick(vq);
> > +
> > +=09/* When host has read buffer, this completes via balloon_ack */
> > +=09wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
>=20
> Is it safe to rely on the same ack-ing mechanism as the inflate/deflate
> queue? What if both mechanisms are used concurrently and race/both wait
> for the hypervisor?
>=20
> Maybe we need a separate vb->acked + callback function.
>=20
> > +}
> > +
> >  static void set_page_pfns(struct virtio_balloon *vb,
> >  =09=09=09  __virtio32 pfns[], struct page *page)
> >  {
> > @@ -476,6 +511,7 @@ static int init_vqs(struct virtio_balloon *vb)
> >  =09names[VIRTIO_BALLOON_VQ_DEFLATE] =3D "deflate";
> >  =09names[VIRTIO_BALLOON_VQ_STATS] =3D NULL;
> >  =09names[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> > +=09names[VIRTIO_BALLOON_VQ_REPORTING] =3D NULL;
> > =20
> >  =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> >  =09=09names[VIRTIO_BALLOON_VQ_STATS] =3D "stats";
> > @@ -487,11 +523,19 @@ static int init_vqs(struct virtio_balloon *vb)
> >  =09=09callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] =3D NULL;
> >  =09}
> > =20
> > +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +=09=09names[VIRTIO_BALLOON_VQ_REPORTING] =3D "reporting_vq";
> > +=09=09callbacks[VIRTIO_BALLOON_VQ_REPORTING] =3D balloon_ack;
> > +=09}
> > +
> >  =09err =3D vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
> >  =09=09=09=09=09 vqs, callbacks, names, NULL, NULL);
> >  =09if (err)
> >  =09=09return err;
> > =20
> > +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > +=09=09vb->reporting_vq =3D vqs[VIRTIO_BALLOON_VQ_REPORTING];
> > +
>=20
> I'd register these in the same order they are defined (IOW, move this
> further down)
>=20
> >  =09vb->inflate_vq =3D vqs[VIRTIO_BALLOON_VQ_INFLATE];
> >  =09vb->deflate_vq =3D vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> >  =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > @@ -932,12 +976,30 @@ static int virtballoon_probe(struct virtio_device=
 *vdev)
> >  =09=09if (err)
> >  =09=09=09goto out_del_balloon_wq;
> >  =09}
> > +
> > +=09vb->pr_dev_info.report =3D virtballoon_unused_page_report;
> > +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +=09=09unsigned int capacity;
> > +
> > +=09=09capacity =3D min_t(unsigned int,
> > +=09=09=09=09 virtqueue_get_vring_size(vb->reporting_vq),
> > +=09=09=09=09 VIRTIO_BALLOON_VRING_HINTS_MAX);
> > +=09=09vb->pr_dev_info.capacity =3D capacity;
> > +
> > +=09=09err =3D page_reporting_register(&vb->pr_dev_info);
> > +=09=09if (err)
> > +=09=09=09goto out_unregister_shrinker;
> > +=09}
>=20
> It can happen here that we start reporting before marking the device
> ready. Can that be problematic?
>=20
> Maybe we have to ignore any reports in virtballoon_unused_page_report()
> until ready...
>=20
> > +
> >  =09virtio_device_ready(vdev);
> > =20
> >  =09if (towards_target(vb))
> >  =09=09virtballoon_changed(vdev);
> >  =09return 0;
> > =20
> > +out_unregister_shrinker:
> > +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> > +=09=09virtio_balloon_unregister_shrinker(vb);
>=20
> A sync is done implicitly, right? So after this call, we won't get any
> new callbacks/are stuck in a callback.
>=20
> >  out_del_balloon_wq:
> >  =09if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> >  =09=09destroy_workqueue(vb->balloon_wq);
> > @@ -966,6 +1028,8 @@ static void virtballoon_remove(struct virtio_devic=
e *vdev)
> >  {
> >  =09struct virtio_balloon *vb =3D vdev->priv;
> > =20
> > +=09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > +=09=09page_reporting_unregister(&vb->pr_dev_info);
>=20
> Dito, same question regarding syncs.
>=20
> >  =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> >  =09=09virtio_balloon_unregister_shrinker(vb);
> >  =09spin_lock_irq(&vb->stop_update_lock);
> > @@ -1038,6 +1102,7 @@ static int virtballoon_validate(struct virtio_dev=
ice *vdev)
> >  =09VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
> >  =09VIRTIO_BALLOON_F_FREE_PAGE_HINT,
> >  =09VIRTIO_BALLOON_F_PAGE_POISON,
> > +=09VIRTIO_BALLOON_F_REPORTING,
> >  };
> > =20
> >  static struct virtio_driver virtio_balloon_driver =3D {
> > diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/v=
irtio_balloon.h
> > index a1966cd7b677..19974392d324 100644
> > --- a/include/uapi/linux/virtio_balloon.h
> > +++ b/include/uapi/linux/virtio_balloon.h
> > @@ -36,6 +36,7 @@
> >  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM=092 /* Deflate balloon on OOM =
*/
> >  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT=093 /* VQ to report free pages=
 */
> >  #define VIRTIO_BALLOON_F_PAGE_POISON=094 /* Guest is using page poison=
ing */
> > +#define VIRTIO_BALLOON_F_REPORTING=095 /* Page reporting virtqueue */
> > =20
> >  /* Size of a PFN in the balloon interface. */
> >  #define VIRTIO_BALLOON_PFN_SHIFT 12
> >=20
> >=20
>=20
> Small and powerful patch :)
>=20
> --=20
> Thanks,
>=20
> David / dhildenb

