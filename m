Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CC47D6CAD
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 15:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343826AbjJYNF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbjJYNFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:05:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6354116
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698239104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+eGNkOk4gCjerW34nyd8PRN31pC/k1qKP3nlpXsfr0=;
        b=agC9jmKpI7MS1CcBUbbPoOWmrV7opdcXCysJPLlaCidjR8PHoMvuiahlGH3WTjMHua0Io3
        a3VcJcbXU2FHRwXZZifBiDW+fSwkDmMpTKh4WzcwHi/ZKIKzkgeCUvPbI1jvuGqxBb6Syr
        8QA+cNlP234jaWCbjP6S+eSpONrDIJQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-JI4Nw6cBPoSmezRZwNpl9A-1; Wed, 25 Oct 2023 09:04:28 -0400
X-MC-Unique: JI4Nw6cBPoSmezRZwNpl9A-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe1521678fso37143845e9.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 06:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239055; x=1698843855;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2+eGNkOk4gCjerW34nyd8PRN31pC/k1qKP3nlpXsfr0=;
        b=oRHXguAK+fwoblI0AifppOZX6dITHA7tQZ+3w+ZPGBCOYeScZH+0mjGvdbruSPsyCY
         mPE0SZDssjKrpOJEDCbxLj06xPwYPO11lZyfgRH4H80lfh6TLqvrh6jddtI9SygAC4uH
         2vmyUxtfZ1hZVN45rNG76LKhJQful42xP5JmBYrrVU1Qq0vTVhvKAKHelwFxKIQ8sE+R
         AJpUaaM+xDglN4vjatPH/S0MtF7dFLP5CYUKJkLi+V8wuP0duHGX2y56DSJNwjcaD1qM
         cK3vLBzBd6A6aX8zYpLirQvnUb7BULkSbjg8nqJDAVh/MGLg0NV7M6ROeIDKrB07FQAC
         IXAA==
X-Gm-Message-State: AOJu0YxbzeCsWfHrQihXUU3w/cw9uCTHOBUajE/I+FIxn1vf+Li2uBQ+
        o6RV4jCH10OxXwhkhP8/ZfRSlOuz396A8CAb+ZmV0Y2VpMbLnAMiGlqIa9lB/uZ4uyDftnZOtcc
        flmjXiD9MbVAS
X-Received: by 2002:a05:600c:45cb:b0:401:bd2e:49fc with SMTP id s11-20020a05600c45cb00b00401bd2e49fcmr11487618wmo.24.1698239055619;
        Wed, 25 Oct 2023 06:04:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJgF5Td5iKRNxlZwYCYOYTwB8jqs9cMPIQ2OCrcXQesOvouTp4oX9t3udgLI2ruEwKxP6srw==
X-Received: by 2002:a05:600c:45cb:b0:401:bd2e:49fc with SMTP id s11-20020a05600c45cb00b00401bd2e49fcmr11487520wmo.24.1698239053870;
        Wed, 25 Oct 2023 06:04:13 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f1:7547:f72e:6bd0:1eb2:d4b5])
        by smtp.gmail.com with ESMTPSA id p30-20020a05600c1d9e00b003fefaf299b6sm14453915wms.38.2023.10.25.06.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:04:13 -0700 (PDT)
Date:   Wed, 25 Oct 2023 09:04:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Message-ID: <20231025090311-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-7-yishaih@nvidia.com>
 <20231024165210-mutt-send-email-mst@kernel.org>
 <5a83e6c1-1d32-4edb-a01c-3660ab74d875@nvidia.com>
 <20231025060501-mutt-send-email-mst@kernel.org>
 <03c4e0da-7a5c-44bc-98f8-fca8228a9674@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03c4e0da-7a5c-44bc-98f8-fca8228a9674@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 04:00:43PM +0300, Yishai Hadas wrote:
> On 25/10/2023 13:17, Michael S. Tsirkin wrote:
> > On Wed, Oct 25, 2023 at 12:18:32PM +0300, Yishai Hadas wrote:
> > > On 25/10/2023 0:01, Michael S. Tsirkin wrote:
> > > 
> > >      On Tue, Oct 17, 2023 at 04:42:14PM +0300, Yishai Hadas wrote:
> > > 
> > >          Introduce APIs to execute legacy IO admin commands.
> > > 
> > >          It includes: list_query/use, io_legacy_read/write,
> > >          io_legacy_notify_info.
> > > 
> > >          Those APIs will be used by the next patches from this series.
> > > 
> > >          Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > >          ---
> > >           drivers/virtio/virtio_pci_common.c |  11 ++
> > >           drivers/virtio/virtio_pci_common.h |   2 +
> > >           drivers/virtio/virtio_pci_modern.c | 206 +++++++++++++++++++++++++++++
> > >           include/linux/virtio_pci_admin.h   |  18 +++
> > >           4 files changed, 237 insertions(+)
> > >           create mode 100644 include/linux/virtio_pci_admin.h
> > > 
> > >          diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> > >          index 6b4766d5abe6..212d68401d2c 100644
> > >          --- a/drivers/virtio/virtio_pci_common.c
> > >          +++ b/drivers/virtio/virtio_pci_common.c
> > >          @@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
> > >                  .sriov_configure = virtio_pci_sriov_configure,
> > >           };
> > > 
> > >          +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
> > >          +{
> > >          +       struct virtio_pci_device *pf_vp_dev;
> > >          +
> > >          +       pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
> > >          +       if (IS_ERR(pf_vp_dev))
> > >          +               return NULL;
> > >          +
> > >          +       return &pf_vp_dev->vdev;
> > >          +}
> > >          +
> > >           module_pci_driver(virtio_pci_driver);
> > > 
> > >           MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
> > >          diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> > >          index a21b9ba01a60..2785e61ed668 100644
> > >          --- a/drivers/virtio/virtio_pci_common.h
> > >          +++ b/drivers/virtio/virtio_pci_common.h
> > >          @@ -155,4 +155,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
> > >           int virtio_pci_modern_probe(struct virtio_pci_device *);
> > >           void virtio_pci_modern_remove(struct virtio_pci_device *);
> > > 
> > >          +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
> > >          +
> > >           #endif
> > >          diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> > >          index cc159a8e6c70..00b65e20b2f5 100644
> > >          --- a/drivers/virtio/virtio_pci_modern.c
> > >          +++ b/drivers/virtio/virtio_pci_modern.c
> > >          @@ -719,6 +719,212 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
> > >                  vp_dev->del_vq(&vp_dev->admin_vq.info);
> > >           }
> > > 
> > >          +/*
> > >          + * virtio_pci_admin_list_query - Provides to driver list of commands
> > >          + * supported for the PCI VF.
> > >          + * @dev: VF pci_dev
> > >          + * @buf: buffer to hold the returned list
> > >          + * @buf_size: size of the given buffer
> > >          + *
> > >          + * Returns 0 on success, or negative on failure.
> > >          + */
> > >          +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
> > >          +{
> > >          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > >          +       struct virtio_admin_cmd cmd = {};
> > >          +       struct scatterlist result_sg;
> > >          +
> > >          +       if (!virtio_dev)
> > >          +               return -ENODEV;
> > >          +
> > >          +       sg_init_one(&result_sg, buf, buf_size);
> > >          +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
> > >          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> > >          +       cmd.result_sg = &result_sg;
> > >          +
> > >          +       return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > >          +}
> > >          +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
> > >          +
> > >          +/*
> > >          + * virtio_pci_admin_list_use - Provides to device list of commands
> > >          + * used for the PCI VF.
> > >          + * @dev: VF pci_dev
> > >          + * @buf: buffer which holds the list
> > >          + * @buf_size: size of the given buffer
> > >          + *
> > >          + * Returns 0 on success, or negative on failure.
> > >          + */
> > >          +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
> > >          +{
> > >          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > >          +       struct virtio_admin_cmd cmd = {};
> > >          +       struct scatterlist data_sg;
> > >          +
> > >          +       if (!virtio_dev)
> > >          +               return -ENODEV;
> > >          +
> > >          +       sg_init_one(&data_sg, buf, buf_size);
> > >          +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
> > >          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> > >          +       cmd.data_sg = &data_sg;
> > >          +
> > >          +       return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > >          +}
> > >          +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);
> > > 
> > >      list commands are actually for a group, not for the VF.
> > > 
> > > The VF was given to let the function gets the PF from it.
> > > 
> > > For now, the only existing 'group_type' in the spec is SRIOV, this is why we
> > > hard-coded it internally to match the VF PCI.
> > > 
> > > Alternatively,
> > > We can change the API to get the PF and 'group_type' from the caller to better
> > > match future usage.
> > > However, this will require to export the virtio_pci_vf_get_pf_dev() API outside
> > > virtio-pci.
> > > 
> > > Do you prefer to change to the latter option ?
> > No, there are several points I wanted to make but this
> > was not one of them.
> > 
> > First, for query, I was trying to suggest changing the comment.
> > Something like:
> >           + * virtio_pci_admin_list_query - Provides to driver list of commands
> >           + * supported for the group including the given member device.
> >           + * @dev: member pci device.
> 
> Following your suggestion below, to issue inside virtio the query/use and
> keep its data internally (i.e. on the 'admin_queue' context).
> 
> We may suggest the below API for the upper-layers (e.g. vfio) to be
> exported.
> 
> bool virtio_pci_admin_supported_cmds(struct pci_dev *pdev, u64 cmds)
> 
> It will find the PF from the VF and internally will check on the
> 'admin_queue' context whether the given 'cmds' input is supported.
> 
> Its output will be true/false.
> 
> Makes sense ?

I think I'd just return the commands. But not a big deal.


> > 	
> > 
> > 
> > Second, I don't think using buf/size  like this is necessary.
> > For now we have a small number of commands just work with u64.
> OK, just keep in mind that upon issuing the command towards the controller
> this still needs to be an allocated u64 data on the heap to work properly.
> > 
> > 
> > Third, while list could be an OK API, the use API does not
> > really work. If you call use with one set of parameters for
> > one VF and another for another then they conflict do they not?
> > 
> > So you need virtio core to do the list/use dance for you,
> > save the list of commands on the PF (which again is just u64 for now)
> > and vfio or vdpa or whatnot will just query that.
> > I hope I'm being clear.
> 
> In that case the virtio_pci_admin_list_query() and
> virtio_pci_admin_list_use() won't be exported any more and will be static in
> virtio-pci.
> 
> They will be called internally as part of activating the admin_queue and
> will simply get struct virtio_device* (the PF) instead of struct pci_dev
> *pdev.
> 
> > 
> > 
> > > 
> > > 
> > >          +
> > >          +/*
> > >          + * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
> > >          + * @dev: VF pci_dev
> > >          + * @opcode: op code of the io write command
> > > 
> > >      opcode is actually either VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE
> > >      or VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE correct?
> > > 
> > >      So please just add 2 APIs for this so users don't need to care.
> > >      Could be wrappers around these two things.
> > > 
> > > 
> > > OK.
> > > 
> > > We'll export the below 2 APIs [1] which internally will call
> > > virtio_pci_admin_legacy_io_write() with the proper op code hard-coded.
> > > 
> > > [1]virtio_pci_admin_legacy_device_io_write()
> > >       virtio_pci_admin_legacy_common_io_write()
> > > 
> > > Yishai
> > > 
> > Makes sense.
> 
> OK, we may do the same split for the 'legacy_io_read' commands to be
> symmetric with the 'legacy_io_write', right ?
> 
> Yishai
> 
> > > 
> > >          + * @offset: starting byte offset within the registers to write to
> > >          + * @size: size of the data to write
> > >          + * @buf: buffer which holds the data
> > >          + *
> > >          + * Returns 0 on success, or negative on failure.
> > >          + */
> > >          +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
> > >          +                                    u8 offset, u8 size, u8 *buf)
> > >          +{
> > >          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > >          +       struct virtio_admin_cmd_legacy_wr_data *data;
> > >          +       struct virtio_admin_cmd cmd = {};
> > >          +       struct scatterlist data_sg;
> > >          +       int vf_id;
> > >          +       int ret;
> > >          +
> > >          +       if (!virtio_dev)
> > >          +               return -ENODEV;
> > >          +
> > >          +       vf_id = pci_iov_vf_id(pdev);
> > >          +       if (vf_id < 0)
> > >          +               return vf_id;
> > >          +
> > >          +       data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
> > >          +       if (!data)
> > >          +               return -ENOMEM;
> > >          +
> > >          +       data->offset = offset;
> > >          +       memcpy(data->registers, buf, size);
> > >          +       sg_init_one(&data_sg, data, sizeof(*data) + size);
> > >          +       cmd.opcode = cpu_to_le16(opcode);
> > >          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> > >          +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
> > >          +       cmd.data_sg = &data_sg;
> > >          +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > >          +
> > >          +       kfree(data);
> > >          +       return ret;
> > >          +}
> > >          +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
> > >          +
> > >          +/*
> > >          + * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
> > >          + * @dev: VF pci_dev
> > >          + * @opcode: op code of the io read command
> > >          + * @offset: starting byte offset within the registers to read from
> > >          + * @size: size of the data to be read
> > >          + * @buf: buffer to hold the returned data
> > >          + *
> > >          + * Returns 0 on success, or negative on failure.
> > >          + */
> > >          +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
> > >          +                                   u8 offset, u8 size, u8 *buf)
> > >          +{
> > >          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > >          +       struct virtio_admin_cmd_legacy_rd_data *data;
> > >          +       struct scatterlist data_sg, result_sg;
> > >          +       struct virtio_admin_cmd cmd = {};
> > >          +       int vf_id;
> > >          +       int ret;
> > >          +
> > >          +       if (!virtio_dev)
> > >          +               return -ENODEV;
> > >          +
> > >          +       vf_id = pci_iov_vf_id(pdev);
> > >          +       if (vf_id < 0)
> > >          +               return vf_id;
> > >          +
> > >          +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> > >          +       if (!data)
> > >          +               return -ENOMEM;
> > >          +
> > >          +       data->offset = offset;
> > >          +       sg_init_one(&data_sg, data, sizeof(*data));
> > >          +       sg_init_one(&result_sg, buf, size);
> > >          +       cmd.opcode = cpu_to_le16(opcode);
> > >          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> > >          +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
> > >          +       cmd.data_sg = &data_sg;
> > >          +       cmd.result_sg = &result_sg;
> > >          +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > >          +
> > >          +       kfree(data);
> > >          +       return ret;
> > >          +}
> > >          +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
> > >          +
> > >          +/*
> > >          + * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
> > >          + * information for legacy interface
> > >          + * @dev: VF pci_dev
> > >          + * @req_bar_flags: requested bar flags
> > >          + * @bar: on output the BAR number of the member device
> > >          + * @bar_offset: on output the offset within bar
> > >          + *
> > >          + * Returns 0 on success, or negative on failure.
> > >          + */
> > >          +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
> > >          +                                          u8 req_bar_flags, u8 *bar,
> > >          +                                          u64 *bar_offset)
> > >          +{
> > >          +       struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > >          +       struct virtio_admin_cmd_notify_info_result *result;
> > >          +       struct virtio_admin_cmd cmd = {};
> > >          +       struct scatterlist result_sg;
> > >          +       int vf_id;
> > >          +       int ret;
> > >          +
> > >          +       if (!virtio_dev)
> > >          +               return -ENODEV;
> > >          +
> > >          +       vf_id = pci_iov_vf_id(pdev);
> > >          +       if (vf_id < 0)
> > >          +               return vf_id;
> > >          +
> > >          +       result = kzalloc(sizeof(*result), GFP_KERNEL);
> > >          +       if (!result)
> > >          +               return -ENOMEM;
> > >          +
> > >          +       sg_init_one(&result_sg, result, sizeof(*result));
> > >          +       cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
> > >          +       cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> > >          +       cmd.group_member_id = cpu_to_le64(vf_id + 1);
> > >          +       cmd.result_sg = &result_sg;
> > >          +       ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> > >          +       if (!ret) {
> > >          +               struct virtio_admin_cmd_notify_info_data *entry;
> > >          +               int i;
> > >          +
> > >          +               ret = -ENOENT;
> > >          +               for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
> > >          +                       entry = &result->entries[i];
> > >          +                       if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
> > >          +                               break;
> > >          +                       if (entry->flags != req_bar_flags)
> > >          +                               continue;
> > >          +                       *bar = entry->bar;
> > >          +                       *bar_offset = le64_to_cpu(entry->offset);
> > >          +                       ret = 0;
> > >          +                       break;
> > >          +               }
> > >          +       }
> > >          +
> > >          +       kfree(result);
> > >          +       return ret;
> > >          +}
> > >          +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
> > >          +
> > >           static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
> > >                  .get            = NULL,
> > >                  .set            = NULL,
> > >          diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
> > >          new file mode 100644
> > >          index 000000000000..cb916a4bc1b1
> > >          --- /dev/null
> > >          +++ b/include/linux/virtio_pci_admin.h
> > >          @@ -0,0 +1,18 @@
> > >          +/* SPDX-License-Identifier: GPL-2.0 */
> > >          +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
> > >          +#define _LINUX_VIRTIO_PCI_ADMIN_H
> > >          +
> > >          +#include <linux/types.h>
> > >          +#include <linux/pci.h>
> > >          +
> > >          +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
> > >          +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
> > >          +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
> > >          +                                    u8 offset, u8 size, u8 *buf);
> > >          +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
> > >          +                                   u8 offset, u8 size, u8 *buf);
> > >          +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
> > >          +                                          u8 req_bar_flags, u8 *bar,
> > >          +                                          u64 *bar_offset);
> > >          +
> > >          +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
> > >          --
> > >          2.27.0
> > > 
> > > 

