Return-Path: <kvm+bounces-41736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C79A6C6B0
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 01:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C43CA466233
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 00:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079F2DDDC;
	Sat, 22 Mar 2025 00:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eoZnzRlb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E342E338D;
	Sat, 22 Mar 2025 00:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742603447; cv=none; b=cTG4p0uA+YLqph0VEo2zFVeuXGMxfAMd5UWdRzmrw7dvIjkjXHQWq0GjPonsO7I9Up/iiohj7+tOYAcJmkWUp7OhcjCr4kQ5JtIKFOY4N56UX478nyBnQUOxEqnLO74DJZrqNWgkg0fl1nb5TcoLncOjFsnF26zBCjClNI5MrO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742603447; c=relaxed/simple;
	bh=lN4Q4A9YNgkvH7lpVQ0JhefFRV9Re5xizYrgR+p3TKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=df/7L5DE9Cxi8Dk9VJPbE4OAdNPE6qbSJLiceTRu2bm9ewxr+1L5OzCLkms7VG2f6XmganszDZacW3P89ohrCckatz6RkP4gMNhU57lNdt64CDfjbk8hX2RvY2DH7tySKuWWomnApFz/77T8Np3nEiIijbMlRbT9VrfLsSaxgnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eoZnzRlb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52LNjnbv011028;
	Sat, 22 Mar 2025 00:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=e00NzVFYgAd4gt4uYOzRzXvv1OrjX8bIBRC9EuVAZ
	jA=; b=eoZnzRlb8I6KMFtCeJhSL7bFbQovUiX/hCuCbqiaR+3EVaQI9BncHQvn/
	30/HQhNjK0LNjP2UQKg0JFLcol+lHw6kVoCnTJrXp4m3bbPrte7en79U+sEz8mUI
	nEqWtMX6fTjbJsweqo07nZ9fvvA7Ri8KgFfoD1rW7+KxWnQmOYZ99raOx5QUWiC8
	jHP0uhPnx24ZEga1YBuw/FQs1PVMkhQtoFOEFDH1FDh3TwBq+eBpfNQ+KdENlBBE
	/mHhLKHnsDoehqpJipKn0hdc3E9CjEv/yoEZk6H2Bd5nvL/hSJ44cZIuIgi5LhBn
	RVF8h0uKASf5PmbiqJ9495NdaIQFg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45h852k661-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 00:30:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52LMvJj7004646;
	Sat, 22 Mar 2025 00:30:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dkvu058s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 00:30:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52M0UPct31457794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Mar 2025 00:30:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB59D20043;
	Sat, 22 Mar 2025 00:30:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87FC020040;
	Sat, 22 Mar 2025 00:30:25 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 22 Mar 2025 00:30:25 +0000 (GMT)
From: Halil Pasic <pasic@linux.ibm.com>
To: Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, stable@vger.kernel.org,
        "Maximilian Immanuel Brandtner" <maxbr@linux.ibm.com>
Subject: [PATCH 1/1] virtio_console: fix missing byte order handling for cols and rows
Date: Sat, 22 Mar 2025 01:29:54 +0100
Message-ID: <20250322002954.3129282-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WVWwkCZ8kEb1FH98jTvXiEM2qMbzrBN-
X-Proofpoint-ORIG-GUID: WVWwkCZ8kEb1FH98jTvXiEM2qMbzrBN-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-21_08,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503220002

As per virtio spec the fields cols and rows are specified as little
endian. Although there is no legacy interface requirement that would
state that cols and rows need to be handled as native endian when legacy
interface is used, unlike for the fields of the adjacent struct
virtio_console_control, I decided to err on the side of caution based
on some non-conclusive virtio spec repo archaeology and opt for using
virtio16_to_cpu() much like for virtio_console_control.event. Strictly
by the letter of the spec virtio_le_to_cpu() would have been sufficient.
But when the legacy interface is not used, it boils down to the same.

And when using the legacy interface, the device formatting these as
little endian when the guest is big endian would surprise me more than
it using guest native byte order (which would make it compatible with
the current implementation). Nevertheless somebody trying to implement
the spec following it to the letter could end up forcing little endian
byte order when the legacy interface is in use. So IMHO this ultimately
needs a judgement call by the maintainers.

Fixes: 8345adbf96fc1 ("virtio: console: Accept console size along with resize control message")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Cc: stable@vger.kernel.org # v2.6.35+
---

@Michael: I think it would be nice to add a clarification on the byte
order to be used for cols and rows when the legacy interface is used to
the spec, regardless of what we decide the right byte order is. If
it is native endian that shall be stated much like it is stated for
virtio_console_control. If it is little endian, I would like to add
a sentence that states that unlike for the fields of virtio_console_control
the byte order of the fields of struct virtio_console_resize is little
endian also when the legacy interface is used.

@Maximilian: Would you mind giving this a spin with your implementation
on the device side of things in QEMU?
---
 drivers/char/virtio_console.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 18f92dd44d45..fc698e2b1da1 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1579,8 +1579,8 @@ static void handle_control_message(struct virtio_device *vdev,
 		break;
 	case VIRTIO_CONSOLE_RESIZE: {
 		struct {
-			__u16 rows;
-			__u16 cols;
+			__virtio16 rows;
+			__virtio16 cols;
 		} size;
 
 		if (!is_console_port(port))
@@ -1588,7 +1588,8 @@ static void handle_control_message(struct virtio_device *vdev,
 
 		memcpy(&size, buf->buf + buf->offset + sizeof(*cpkt),
 		       sizeof(size));
-		set_console_size(port, size.rows, size.cols);
+		set_console_size(port, virtio16_to_cpu(vdev, size.rows),
+				 virtio16_to_cpu(vdev, size.cols));
 
 		port->cons.hvc->irq_requested = 1;
 		resize_console(port);

base-commit: b3ee1e4609512dfff642a96b34d7e5dfcdc92d05
-- 
2.45.2


