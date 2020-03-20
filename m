Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB5518D9A8
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgCTUqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:46:18 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35587 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgCTUqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:46:17 -0400
Received: by mail-ed1-f68.google.com with SMTP id a20so8745940edj.2
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 13:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PDiCfVzJR6fbRiqtmPfVAOBY9XV5yzFUyxAY7cQmzw=;
        b=tkGRj8xZJfs2RvgR+4qOK2ziAbf0K6kdOl8ufOPd6164iOO08RbnkY7zFwFfC3DsgM
         ldbMShmk4xhjfhZ8hFfbAKecG+uVtemC5hiXQEC2CVKkOG5y/ad8GOsZnvREFECLGHvX
         smJ1VwBSRYmRXtodlcQNTHsGW9K7BVYEV3f5tZY7Ra5pBpzwfl8BF8s21cztiSBlqRlW
         Fl8uqP9x9Bc+Pdcs6PeZNoqCIkVbSXtmJuJcX4cCJ+4I6Jofbr/X5Iq0lyKwy0ctFq6F
         cd3a+m89Xx+8tIWMhwlTBJ+q1Kwc4mvgC0uInHJKdIAHFSgzBSSoMJoD4hAXMbUbA10R
         bT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PDiCfVzJR6fbRiqtmPfVAOBY9XV5yzFUyxAY7cQmzw=;
        b=Sj0qFwVX6fYzFXO5Ummo9YcDtQcPAwnqxKa6AfH6dz9UEE/dgKY8ksMcp5nkDlbIpt
         8wAxFKGsJBTQ++XX2zj7F/kAQbUmRzTWNlRZvVBXewMrhUn90HE3p6rABpf9ZACHy4fN
         +KNyUbYg+dssndi6w9WfvF+Ss+TRrbdAlQNr3kQnNCzzfw3Fz8OwAxOt8RkR64GC6844
         HajpvshjjX+ce3Kw2E838GuHoZiEigw5kCZdi2vV3gY7tiR2kgLx8yYlIkNa/isFCy3/
         GM+pyvFHkub1Mg/XlZJtJenmxnPniHaa6cjctlAUsWwB/lhnJiENwxBAx5H2KTeok/VP
         sT6A==
X-Gm-Message-State: ANhLgQ1ABB7MqQuPm1gE8PkOURFP6e/vamlSqrY4kdjYpJprHCYXgwJT
        lhyGNhbWdzo4tcniQXf/q/ksS7RJTAsPbNvZ1z+fRw==
X-Google-Smtp-Source: ADFU+vtNahf1ktCk9uXI6lwbWpCy1CyBcl/mn73xmDSWeKU/+hJQIqGxgwfvUbpvn3jz2flPR1KB+RMwMge5xFhjAxk=
X-Received: by 2002:a17:906:7e51:: with SMTP id z17mr9972500ejr.373.1584737175024;
 Fri, 20 Mar 2020 13:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200320175910.180266-1-yonghyun@google.com> <20200320123425.49c6568e@w520.home>
In-Reply-To: <20200320123425.49c6568e@w520.home>
From:   Yonghyun Hwang <yonghyun@google.com>
Date:   Fri, 20 Mar 2020 13:46:04 -0700
Message-ID: <CAEauFbx1Su7Lg5kdxXnvUwfwLCH67qaGB6EZ7g3OOH-tbRfBBA@mail.gmail.com>
Subject: Re: [PATCH] vfio-mdev: support mediated device creation in kernel
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Moritz Fischer <mdf@kernel.org>,
        Joshua Lang <joshualang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 11:34 AM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Fri, 20 Mar 2020 10:59:10 -0700
> Yonghyun Hwang <yonghyun@google.com> wrote:
>
> > To enable a mediated device, a device driver registers its device to VFIO
> > MDev framework. Once the mediated device gets enabled, UUID gets fed onto
> > the sysfs attribute, "create", to create the mediated device. This
> > additional step happens after boot-up gets complete. If the driver knows
> > how many mediated devices need to be created during probing time, the
> > additional step becomes cumbersome. This commit implements a new function
> > to allow the driver to create a mediated device in kernel.
>
> But pre-creating mdev devices seems like a policy decision.  Why can't
> userspace make such a policy decision, and do so with persistent uuids,
> via something like mdevctl?  Thanks,
>
> Alex

Yep, it can be viewed as the policy decision and userspace can make
the decision. However, it would be handy and plausible, if a device
driver can pre-create "fixed or default" # of mdev devices, while
allowing the device policy to come into play after bootup gets
complete. Without this patch, a device driver should release the
policy and the policy should be aligned with the driver, which would
be cumbersome (sometimes painful) in a cloud environment. My use case
with mdev is to enable a subset of vfio-pci features without losing my
device driver.

Thank you,
Yonghyun


>
>
> > Signed-off-by: Yonghyun Hwang <yonghyun@google.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 45 +++++++++++++++++++++++++++++++++++
> >  include/linux/mdev.h          |  3 +++
> >  2 files changed, 48 insertions(+)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > index b558d4cfd082..a6d32516de42 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -350,6 +350,51 @@ int mdev_device_create(struct kobject *kobj,
> >       return ret;
> >  }
> >
> > +/*
> > + * mdev_create_device : Create a mdev device
> > + * @dev: device structure representing parent device.
> > + * @uuid: uuid char string for a mdev device.
> > + * @group: index to supported type groups for a mdev device.
> > + *
> > + * Create a mdev device in kernel.
> > + * Returns a negative value on error, otherwise 0.
> > + */
> > +int mdev_create_device(struct device *dev,
> > +                     const char *uuid, int group)
> > +{
> > +     struct mdev_parent *parent = NULL;
> > +     struct mdev_type *type = NULL;
> > +     guid_t guid;
> > +     int i = 1;
> > +     int ret;
> > +
> > +     ret = guid_parse(uuid, &guid);
> > +     if (ret) {
> > +             dev_err(dev, "Failed to parse UUID");
> > +             return ret;
> > +     }
> > +
> > +     parent = __find_parent_device(dev);
> > +     if (!parent) {
> > +             dev_err(dev, "Failed to find parent mdev device");
> > +             return -ENODEV;
> > +     }
> > +
> > +     list_for_each_entry(type, &parent->type_list, next) {
> > +             if (i == group)
> > +                     break;
> > +             i++;
> > +     }
> > +
> > +     if (!type || i != group) {
> > +             dev_err(dev, "Failed to find mdev device");
> > +             return -ENODEV;
> > +     }
> > +
> > +     return mdev_device_create(&type->kobj, parent->dev, &guid);
> > +}
> > +EXPORT_SYMBOL(mdev_create_device);
> > +
> >  int mdev_device_remove(struct device *dev)
> >  {
> >       struct mdev_device *mdev, *tmp;
> > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > index 0ce30ca78db0..b66f67998916 100644
> > --- a/include/linux/mdev.h
> > +++ b/include/linux/mdev.h
> > @@ -145,4 +145,7 @@ struct device *mdev_parent_dev(struct mdev_device *mdev);
> >  struct device *mdev_dev(struct mdev_device *mdev);
> >  struct mdev_device *mdev_from_dev(struct device *dev);
> >
> > +extern int mdev_create_device(struct device *dev,
> > +                     const char *uuid, int group_idx);
> > +
> >  #endif /* MDEV_H */
>
