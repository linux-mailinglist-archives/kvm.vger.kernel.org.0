Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1213F66651C
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 21:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbjAKUxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 15:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbjAKUxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 15:53:40 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6273DBE4
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 12:53:39 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p24so18037862plw.11
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 12:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ltp+seogK+PxaVsEYogy95r8h77BHMwLLlXz9DiN8w=;
        b=ZkKElg+8IcsEScy6KU15ENBM4hY2OLh2JUmXtCiQe9D357/FhbWQQdTbJ+XgevOLlQ
         eZWwyGY8JM8invv4+POFOm46+9jGIVnHl7vXs4qg8G3YJh+ukYRpWYpSdKzWqldYdRag
         Iuf2HPbQaTOscBk6xESwqqLMjSShui4NJxKzidDiJuFixDGvCf5v0LD7uVodNAW+2KUx
         SbP0aqJY7HzBnc9JRoNoGs/f86bvYvaRMrkMrolcBaBu6QTt34OHz9uDQrqfCQ7AhQsp
         Nn0A0msUsx1Z16wvpmKtG8iKTJopRdDqNCgbtFp3Zt36U360mVfWc0WG+obDtljR4h9+
         jOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ltp+seogK+PxaVsEYogy95r8h77BHMwLLlXz9DiN8w=;
        b=148Mk0Ea/6XzD1zy6aLgPSvfI7snt/Z5ev7AtxCQakttBapB/GE5yhwgQRYs5T9yFL
         U0KcyaY9Op7Jyp2gfDiP/bXX+YuoVfwJ+A7HRgZgk9Tpar62DDBb4Gzqlw5D6BXwz35A
         cgzTxR7w5SxhIZWspQuPvVg8ztljbSxyRjZdCufUApwms2Iviee8766VMDg9Mc/qHKkJ
         rTPMhC8OhC4R5WVZmZFRGoENb2HWTJGCXro/B50CljTE+GWq4qNTMnj446NMi2ff1B5v
         g4u/fVmPY335S6Vj276YWT9+JdmegOp+AzUE3agLv9oNHiwr1YwPfPOFcl6/6UF8Py0l
         4ECQ==
X-Gm-Message-State: AFqh2kqY2mS99xPBioIzgwQLO15WpAHOZ6zplW3iVz5q1s5uoS1IUC5X
        HphhpSIagAOq9CtX69i1z9twrQ==
X-Google-Smtp-Source: AMrXdXtc4CpOFmwV1Hw4NH/1QoEjdUGEehsu8+s0heNHbjQKL27VEfPV1Z8tPmwPD/xRgsHw1J4USA==
X-Received: by 2002:a05:6a20:c527:b0:9d:c38f:9bdd with SMTP id gm39-20020a056a20c52700b0009dc38f9bddmr581152pzb.2.1673470418329;
        Wed, 11 Jan 2023 12:53:38 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902654b00b001895d87225csm10569179pln.182.2023.01.11.12.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 12:53:37 -0800 (PST)
Date:   Wed, 11 Jan 2023 20:53:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
Message-ID: <Y78hzsHiwaFpL60+@google.com>
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
 <20230109201037.33051-2-mjrosato@linux.ibm.com>
 <Y78UCz5oeuntSQtK@google.com>
 <Y78Wk2/P5+gLMdpk@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y78Wk2/P5+gLMdpk@nvidia.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023, Jason Gunthorpe wrote:
> On Wed, Jan 11, 2023 at 07:54:51PM +0000, Sean Christopherson wrote:
> 
> > Something feels off.  If KVM's refcount is 0, then accessing device->group->kvm
> > in vfio_device_open() can't happen unless there's a refcounting bug somewhere.
> 
> The problem is in close, not open.

The deadlock problem is, yes.  My point is that if group_lock needs to be taken
when nullifying group->kvm during kvm_vfio_destroy(), then there is also a refcounting
prolem with respect to open().  If there is no refcounting problem, then nullifying
group->kvm during kvm_vfio_destroy() is unnecessary (but again, I doubt this is
the case).

The two things aren't directly related, but it seems possible to solve both while
making this all slightly less ugly.  Well, at least from KVM's perspective, whether
or not it'd be an improvement on the VFIO side is definitely debatable.

> Specifically it would be very hard to avoid holding the group_lock
> during close which is when the put is done.
> 
> > Rather than force devices to get KVM references, why not handle that in common
> > VFIO code and drop KVM refcountin from devices?  Worst case scenario KVM is pinned
> > by a device that doesn't need KVM but is in a group associated with KVM.  If that's
> > a concern, it seems easy enough to add a flag to vfio_device_ops to enumerate
> > whether or not the device depends on KVM.
> 
> We can't make cross-dependencies between kvm and core VFIO - it is why
> so much of this is soo ugly.

Ugh, right, modules for everyone.

> The few device drivers that unavoidably have KVM involvment already
> have a KVM module dependency, so they can safely do the get/put

Rather than store a "struct kvm *" in vfio_device, what about adding a new set
of optional ops to get/put KVM references?  Having dedicated KVM ops is gross,
but IMO it's less gross than backdooring the KVM pointer into open_device() by
stashing KVM into the device, e.g. it formalizes the VFIO API for devices that
depend on KVM instead of making devices pinky-swear to grab a reference during
open_device().

To further harden things, KVM could export only kvm_get_safe_kvm() if there are
no vendor modules.  I.e. make kvm_get_kvm() an internal-only helper when possible
and effectively force VFIO devices to use the safe variant.  That would work even
x86, as kvm_get_kvm() wouldn't be exported if neither KVM_AMD nor KVM_INTEL is
built as a module.

---
 drivers/vfio/vfio_main.c | 20 +++++++++++++-------
 include/linux/vfio.h     |  9 +++++++--
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6e8804fe0095..b3a84d65baa6 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -772,7 +772,12 @@ static struct file *vfio_device_open(struct vfio_device *device)
 		 * reference and release it during close_device.
 		 */
 		mutex_lock(&device->group->group_lock);
-		device->kvm = device->group->kvm;
+
+		if (device->kvm_ops && device->group->kvm) {
+			ret = device->kvm_ops->get_kvm(device->group->kvm);
+			if (ret)
+				goto err_undo_count;
+		}
 
 		if (device->ops->open_device) {
 			ret = device->ops->open_device(device);
@@ -823,8 +828,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 err_undo_count:
 	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
-	if (device->open_count == 0 && device->kvm)
-		device->kvm = NULL;
+	if (device->open_count == 0 && device->kvm_ops)
+		device->kvm_ops->put_kvm();
+
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
 err_unassign_container:
@@ -1039,8 +1045,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	}
 	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
-	if (device->open_count == 0)
-		device->kvm = NULL;
+	if (device->open_count == 0 && device->kvm_ops)
+		device->kvm_ops->put_kvm();
 	mutex_unlock(&device->dev_set->lock);
 
 	module_put(device->dev->driver->owner);
@@ -1656,8 +1662,8 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
  * @file: VFIO group file
  * @kvm: KVM to link
  *
- * When a VFIO device is first opened the KVM will be available in
- * device->kvm if one was associated with the group.
+ * When a VFIO device is first opened, the device's kvm_ops->get_kvm() will be
+ * invoked with the KVM instance associated with the group (if applicable).
  */
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index fdd393f70b19..d6dcbe0546bf 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -18,6 +18,11 @@
 
 struct kvm;
 
+struct vfio_device_kvm_ops {
+	int (*get_kvm)(struct kvm *kvm);
+	void (*put_kvm)(void);
+};
+
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
  * structure and the VFIO core will provide a lock that is held around
@@ -43,8 +48,8 @@ struct vfio_device {
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
-	/* Driver must reference the kvm during open_device or never touch it */
-	struct kvm *kvm;
+
+	const struct vfio_device_kvm_ops *kvm_ops;
 
 	/* Members below here are private, not for driver use */
 	unsigned int index;

base-commit: d52444c7a90fc551b4c3b0bda7d3f0b2ca9fc84d
-- 

