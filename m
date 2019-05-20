Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CCC22D62
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 09:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbfETHuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 03:50:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60560 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728551AbfETHuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 03:50:18 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 013E9E36936FEED85244;
        Mon, 20 May 2019 15:50:16 +0800 (CST)
Received: from [127.0.0.1] (10.177.16.168) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 May 2019
 15:50:15 +0800
To:     <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>
From:   jiangyiwen <jiangyiwen@huawei.com>
Subject: [bug report] vfio: Can't find phys by iova in vfio_unmap_unpin()
Message-ID: <5CE25C33.2060009@huawei.com>
Date:   Mon, 20 May 2019 15:50:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.16.168]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello alex,

We test a call trace as follows use ARM64 architecture,
it prints a WARN_ON() when find not physical address by
iova in vfio_unmap_unpin(), I can't find the cause of
problem now, do you have any ideas?

In addition, I want to know why there is a WARN_ON() instead
of BUG_ON()? Does it affect the follow-up process?

Thanks,
Yiwen.

2019-05-17T15:43:36.565426+08:00|warning|kernel[-]|[12727.392078] WARNING: CPU: 70 PID: 13816 at drivers/vfio/vfio_iommu_type1.c:795 vfio_unmap_unpin+0x300/0x370
2019-05-17T15:43:36.565501+08:00|warning|kernel[-]|[12727.392083] Modules linked in: dm_service_time dm_multipath ebtable_filter ebtables ip6table_filter ip6_tables dev_connlimit(O) vhba(O) iptable_filter elbtrans(O) vm_eth_qos(O) vm_pps_qos(O) vm_bps_qos(O) bum(O) ip_set nfnetlink prio(O) nat(O) vport_vxlan(O) openvswitch(O) nf_nat_ipv6 nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 gre signo_catch(O) hotpatch(O) gcn_hotpatch(O) kboxdriver(O) kbox(O) ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib ib_umad rpcrdma sunrpc rdma_ucm ib_uverbs ib_iser rdma_cm iw_cm ib_cm aes_ce_blk crypto_simd cryptd ses aes_ce_cipher enclosure crc32_ce ghash_ce sbsa_gwdt sha2_ce sha256_arm64 sha1_ce hinic sg hibmc_drm ttm drm_kms_helper drm fb_sys_fops syscopyarea sysfillrect sysimgblt hns_roce_hw_v2 hns_roce ib_core
2019-05-17T15:43:36.566357+08:00|warning|kernel[-]|[12727.392156]  realtek hns3 hclge hnae3 remote_trigger(O) vhost_net(O) tun(O) vhost(O) tap ip_tables dm_mod ipmi_si ipmi_devintf ipmi_msghandler megaraid_sas hisi_sas_v3_hw hisi_sas_main br_netfilter xt_sctp
2019-05-17T15:43:36.566371+08:00|warning|kernel[-]|[12727.392178] CPU: 70 PID: 13816 Comm: vnc_worker Kdump: loaded Tainted: G           O      4.19.36-1.2.142.aarch64 #1
2019-05-17T15:43:36.566383+08:00|warning|kernel[-]|[12727.392179] Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 0.12 05/14/2019
2019-05-17T15:43:36.566394+08:00|warning|kernel[-]|[12727.392181] pstate: 80400009 (Nzcv daif +PAN -UAO)
2019-05-17T15:43:36.566404+08:00|warning|kernel[-]|[12727.392182] pc : vfio_unmap_unpin+0x300/0x370
2019-05-17T15:43:36.566414+08:00|warning|kernel[-]|[12727.392183] lr : vfio_unmap_unpin+0xe4/0x370
2019-05-17T15:43:36.566425+08:00|warning|kernel[-]|[12727.392184] sp : ffff0000216eb950
2019-05-17T15:43:36.566439+08:00|warning|kernel[-]|[12727.392185] x29: ffff0000216eb950 x28: ffffa05deef8e280
2019-05-17T15:43:36.566449+08:00|warning|kernel[-]|[12727.392187] x27: ffffa05deef8fa80 x26: ffff8042055f6688
2019-05-17T15:43:36.566460+08:00|warning|kernel[-]|[12727.392189] x25: ffff0000216eb9d8 x24: 00000000008b29d8
2019-05-17T15:43:36.566470+08:00|warning|kernel[-]|[12727.392191] x23: ffff804104c5b700 x22: 00000008fb51e000
2019-05-17T15:43:36.566480+08:00|warning|kernel[-]|[12727.392193] x21: 0000000a40000000 x20: 0000000000000000
2019-05-17T15:43:36.566490+08:00|warning|kernel[-]|[12727.392195] x19: ffff8042055f6680 x18: ffff000009605d28
2019-05-17T15:43:36.566501+08:00|warning|kernel[-]|[12727.392197] x17: 0000000000000000 x16: 000000000000000c
2019-05-17T15:43:36.566511+08:00|warning|kernel[-]|[12727.392199] x15: 00000000ffffffff x14: 000000000000003f
2019-05-17T15:43:36.566523+08:00|warning|kernel[-]|[12727.392201] x13: 0000000000001000 x12: 0000000000000000
2019-05-17T15:43:36.566533+08:00|warning|kernel[-]|[12727.392203] x11: ffff805d7aa8df00 x10: 000000000000000c
2019-05-17T15:43:36.566543+08:00|warning|kernel[-]|[12727.392205] x9 : 000000000000000c x8 : 0000000000000000
2019-05-17T15:43:36.566554+08:00|warning|kernel[-]|[12727.392207] x7 : 0000000000000009 x6 : 00000000ffffffff
2019-05-17T15:43:36.566564+08:00|warning|kernel[-]|[12727.392209] x5 : 0000000000000000 x4 : 0000000000000001
2019-05-17T15:43:36.566576+08:00|warning|kernel[-]|[12727.392211] x3 : 0000000000000001 x2 : 0000000000000000
2019-05-17T15:43:36.566586+08:00|warning|kernel[-]|[12727.392213] x1 : 0000000000000000 x0 : 0000000000000000
2019-05-17T15:43:36.566597+08:00|warning|kernel[-]|[12727.392215] Call trace:
2019-05-17T15:43:36.566607+08:00|warning|kernel[-]|[12727.392217]  vfio_unmap_unpin+0x300/0x370
2019-05-17T15:43:36.566618+08:00|warning|kernel[-]|[12727.392218]  vfio_remove_dma+0x2c/0x80
2019-05-17T15:43:36.566628+08:00|warning|kernel[-]|[12727.392220]  vfio_iommu_unmap_unpin_all+0x2c/0x48
2019-05-17T15:43:36.566638+08:00|warning|kernel[-]|[12727.392221]  vfio_iommu_type1_detach_group+0x2e8/0x2f0
2019-05-17T15:43:36.566648+08:00|warning|kernel[-]|[12727.392226]  __vfio_group_unset_container+0x54/0x180
2019-05-17T15:43:36.566659+08:00|warning|kernel[-]|[12727.392228]  vfio_group_try_dissolve_container+0x54/0x68
2019-05-17T15:43:36.566669+08:00|warning|kernel[-]|[12727.392230]  vfio_group_put_external_user+0x20/0x38
2019-05-17T15:43:36.566680+08:00|warning|kernel[-]|[12727.392235]  kvm_vfio_group_put_external_user+0x38/0x50
2019-05-17T15:43:36.566690+08:00|warning|kernel[-]|[12727.392236]  kvm_vfio_destroy+0x5c/0xc8
2019-05-17T15:43:36.566700+08:00|warning|kernel[-]|[12727.392237]  kvm_put_kvm+0x1c8/0x2e0
2019-05-17T15:43:36.566710+08:00|warning|kernel[-]|[12727.392239]  kvm_vm_release+0x2c/0x40
2019-05-17T15:43:36.566721+08:00|warning|kernel[-]|[12727.392243]  __fput+0xac/0x218
2019-05-17T15:43:36.566731+08:00|warning|kernel[-]|[12727.392244]  ____fput+0x20/0x30
2019-05-17T15:43:36.566741+08:00|warning|kernel[-]|[12727.392247]  task_work_run+0xc0/0xf8
2019-05-17T15:43:36.566751+08:00|warning|kernel[-]|[12727.392250]  do_exit+0x300/0x5b0
2019-05-17T15:43:36.566761+08:00|warning|kernel[-]|[12727.392251]  do_group_exit+0x3c/0xe0
2019-05-17T15:43:36.566772+08:00|warning|kernel[-]|[12727.392254]  get_signal+0x12c/0x6e0
2019-05-17T15:43:36.566783+08:00|warning|kernel[-]|[12727.392257]  do_signal+0x180/0x288
2019-05-17T15:43:36.566793+08:00|warning|kernel[-]|[12727.392259]  do_notify_resume+0x100/0x188
2019-05-17T15:43:36.566804+08:00|warning|kernel[-]|[12727.392261]  work_pending+0x8/0x10
2019-05-17T15:43:36.566814+08:00|warning|kernel[-]|[12727.392263] ---[ end trace 12212429631eec72 ]---

