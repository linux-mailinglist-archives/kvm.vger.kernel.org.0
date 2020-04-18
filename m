Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9854B1AEBC1
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 12:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDRKYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 06:24:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgDRKWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Apr 2020 06:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587205364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J5lJZiq3WmQwvXVuOcS6LJd0GHMf+A3ixFB5Oid+SF0=;
        b=JTirg4iZCfHtm3pMq4oGWKTCFxB1nhHVsWirEzfeSgwXHyM/u1PO7s71Tyvtcx++23i6+6
        QYuo5e2Dob4Rb3gaHZ0oOMgTBJONBI7qFnNRWbV9usO2na4v+Txk4bfY6TtS2NNq0Sd/zk
        tSwJ9wYZXNeu43NQB3pyt0awa+ze8no=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-1Xi4lD3wOYCN-tS_8EHE-w-1; Sat, 18 Apr 2020 06:22:40 -0400
X-MC-Unique: 1Xi4lD3wOYCN-tS_8EHE-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B1C28018A3;
        Sat, 18 Apr 2020 10:22:39 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 344151000325;
        Sat, 18 Apr 2020 10:22:37 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm list <kvm@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: [PATCH v3 4/8] tools/virtio: Add --reset
Date:   Sat, 18 Apr 2020 12:22:13 +0200
Message-Id: <20200418102217.32327-5-eperezma@redhat.com>
In-Reply-To: <20200418102217.32327-1-eperezma@redhat.com>
References: <20200418102217.32327-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, it only removes and add backend, but it will reset vq
position in future commits.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/test.c       | 57 ++++++++++++++++++++++++++++++++++++++
 drivers/vhost/test.h       |  1 +
 tools/virtio/virtio_test.c | 41 ++++++++++++++++++++++++---
 3 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 02806d6f84ef..6aed0cab8b17 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -263,9 +263,62 @@ static int vhost_test_set_features(struct vhost_test=
 *n, u64 features)
 	return 0;
 }
=20
+static long vhost_test_set_backend(struct vhost_test *n, unsigned index,=
 int fd)
+{
+	static void *backend;
+
+	const bool enable =3D fd !=3D -1;
+	struct vhost_virtqueue *vq;
+	int r;
+
+	mutex_lock(&n->dev.mutex);
+	r =3D vhost_dev_check_owner(&n->dev);
+	if (r)
+		goto err;
+
+	if (index >=3D VHOST_TEST_VQ_MAX) {
+		r =3D -ENOBUFS;
+		goto err;
+	}
+	vq =3D &n->vqs[index];
+	mutex_lock(&vq->mutex);
+
+	/* Verify that ring has been setup correctly. */
+	if (!vhost_vq_access_ok(vq)) {
+		r =3D -EFAULT;
+		goto err_vq;
+	}
+	if (!enable) {
+		vhost_poll_stop(&vq->poll);
+		backend =3D vhost_vq_get_backend(vq);
+		vhost_vq_set_backend(vq, NULL);
+	} else {
+		vhost_vq_set_backend(vq, backend);
+		r =3D vhost_vq_init_access(vq);
+		if (r =3D=3D 0)
+			r =3D vhost_poll_start(&vq->poll, vq->kick);
+	}
+
+	mutex_unlock(&vq->mutex);
+
+	if (enable) {
+		vhost_test_flush_vq(n, index);
+	}
+
+	mutex_unlock(&n->dev.mutex);
+	return 0;
+
+err_vq:
+	mutex_unlock(&vq->mutex);
+err:
+	mutex_unlock(&n->dev.mutex);
+	return r;
+}
+
 static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			     unsigned long arg)
 {
+	struct vhost_vring_file backend;
 	struct vhost_test *n =3D f->private_data;
 	void __user *argp =3D (void __user *)arg;
 	u64 __user *featurep =3D argp;
@@ -277,6 +330,10 @@ static long vhost_test_ioctl(struct file *f, unsigne=
d int ioctl,
 		if (copy_from_user(&test, argp, sizeof test))
 			return -EFAULT;
 		return vhost_test_run(n, test);
+	case VHOST_TEST_SET_BACKEND:
+		if (copy_from_user(&backend, argp, sizeof backend))
+			return -EFAULT;
+		return vhost_test_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
 		features =3D VHOST_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
diff --git a/drivers/vhost/test.h b/drivers/vhost/test.h
index 7dd265bfdf81..822bc4bee03a 100644
--- a/drivers/vhost/test.h
+++ b/drivers/vhost/test.h
@@ -4,5 +4,6 @@
=20
 /* Start a given test on the virtio null device. 0 stops all tests. */
 #define VHOST_TEST_RUN _IOW(VHOST_VIRTIO, 0x31, int)
+#define VHOST_TEST_SET_BACKEND _IOW(VHOST_VIRTIO, 0x32, int)
=20
 #endif
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 4a2b9d11f287..6bc3e172cc9b 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -46,6 +46,9 @@ struct vdev_info {
 	struct vhost_memory *mem;
 };
=20
+static const struct vhost_vring_file no_backend =3D { .fd =3D -1 },
+				     backend =3D { .fd =3D 1 };
+
 bool vq_notify(struct virtqueue *vq)
 {
 	struct vq_info *info =3D vq->priv;
@@ -155,10 +158,10 @@ static void wait_for_interrupt(struct vdev_info *de=
v)
 }
=20
 static void run_test(struct vdev_info *dev, struct vq_info *vq,
-		     bool delayed, int batch, int bufs)
+		     bool delayed, int batch, int reset_n, int bufs)
 {
 	struct scatterlist sl;
-	long started =3D 0, completed =3D 0;
+	long started =3D 0, completed =3D 0, next_reset =3D reset_n;
 	long completed_before, started_before;
 	int r, test =3D 1;
 	unsigned len;
@@ -171,6 +174,7 @@ static void run_test(struct vdev_info *dev, struct vq=
_info *vq,
 		completed_before =3D completed;
 		started_before =3D started;
 		do {
+			const bool reset =3D reset_n && completed > next_reset;
 			if (random_batch)
 				batch =3D (random() % vq->vring.num) + 1;
=20
@@ -200,12 +204,26 @@ static void run_test(struct vdev_info *dev, struct =
vq_info *vq,
 			if (started >=3D bufs)
 				r =3D -1;
=20
+			if (reset) {
+				r =3D ioctl(dev->control, VHOST_TEST_SET_BACKEND,
+					  &no_backend);
+				assert(!r);
+			}
+
 			/* Flush out completed bufs if any */
 			while (virtqueue_get_buf(vq->vq, &len)) {
 				++completed;
 				r =3D 0;
 			}
=20
+			if (reset) {
+				r =3D ioctl(dev->control, VHOST_TEST_SET_BACKEND,
+					  &backend);
+				assert(!r);
+
+				while (completed > next_reset)
+					next_reset +=3D completed;
+			}
 		} while (r =3D=3D 0);
 		if (completed =3D=3D completed_before && started =3D=3D started_before=
)
 			++spurious;
@@ -270,6 +288,11 @@ const struct option longopts[] =3D {
 		.val =3D 'b',
 		.has_arg =3D required_argument,
 	},
+	{
+		.name =3D "reset",
+		.val =3D 'r',
+		.has_arg =3D optional_argument,
+	},
 	{
 	}
 };
@@ -282,6 +305,7 @@ static void help(void)
 		" [--no-virtio-1]"
 		" [--delayed-interrupt]"
 		" [--batch=3Drandom/N]"
+		" [--reset=3DN]"
 		"\n");
 }
=20
@@ -290,7 +314,7 @@ int main(int argc, char **argv)
 	struct vdev_info dev;
 	unsigned long long features =3D (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
 		(1ULL << VIRTIO_RING_F_EVENT_IDX) | (1ULL << VIRTIO_F_VERSION_1);
-	long batch =3D 1;
+	long batch =3D 1, reset =3D 0;
 	int o;
 	bool delayed =3D false;
=20
@@ -326,6 +350,15 @@ int main(int argc, char **argv)
 				assert(batch < (long)INT_MAX + 1);
 			}
 			break;
+		case 'r':
+			if (!optarg) {
+				reset =3D 1;
+			} else {
+				reset =3D strtol(optarg, NULL, 10);
+				assert(reset > 0);
+				assert(reset < (long)INT_MAX + 1);
+			}
+			break;
 		default:
 			assert(0);
 			break;
@@ -335,6 +368,6 @@ int main(int argc, char **argv)
 done:
 	vdev_info_init(&dev, features);
 	vq_info_add(&dev, 256);
-	run_test(&dev, &dev.vqs[0], delayed, batch, 0x100000);
+	run_test(&dev, &dev.vqs[0], delayed, batch, reset, 0x100000);
 	return 0;
 }
--=20
2.18.1

